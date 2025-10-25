#!/usr/bin/env bash
# Harden an Ubuntu VPS with sensible defaults: creates a sudo user, configures SSH, UFW, Fail2Ban,
# enables unattended upgrades, and applies basic kernel hardening. Designed for first-run security.
set -euo pipefail

export DEBIAN_FRONTEND="${DEBIAN_FRONTEND:-noninteractive}"
export NEEDRESTART_MODE="${NEEDRESTART_MODE:-a}"
umask 027

log() {
  printf '\n[%s] %s\n' "$(date -u '+%Y-%m-%d %H:%M:%S UTC')" "$*"
}

fatal() {
  printf '\n[ERROR] %s\n' "$*" >&2
  exit 1
}

trap 'fatal "Script aborted at line ${LINENO}. Check the log above for details."' ERR

require_root() {
  if [[ "$(id -u)" -ne 0 ]]; then
    fatal "Please run this script as root (e.g. sudo bash $0)."
  fi
}

prompt() {
  local __prompt="$1" __default="$2" __var
  read -r -p "$__prompt" __var || true
  if [[ -z "$__var" ]]; then
    printf '%s' "$__default"
  else
    printf '%s' "$__var"
  fi
}

ensure_valid_port() {
  local __port="$1"
  if ! [[ "$__port" =~ ^[0-9]+$ ]] || (( __port < 1 || __port > 65535 )); then
    fatal "Port '$__port' is invalid. Choose a value between 1 and 65535."
  fi
}

setup_variables() {
  if [[ -t 0 ]]; then
    NEW_USER="${NEW_ADMIN_USER:-$(prompt "Enter the name for the privileged user [deploy]: " "deploy" )}"
    SSH_PORT="${HARDENED_SSH_PORT:-$(prompt "SSH port to allow [22]: " "22" )}"
    SSH_KEY="${NEW_ADMIN_SSH_KEY:-$(prompt "Paste an SSH public key for ${NEW_USER} (leave blank to skip): " "" )}"
    ALLOW_WEB="${ALLOW_WEB_TRAFFIC:-$(prompt "Allow HTTP/HTTPS traffic through UFW? [Y/n]: " "Y" )}"
  else
    NEW_USER="${NEW_ADMIN_USER:-deploy}"
    SSH_PORT="${HARDENED_SSH_PORT:-22}"
    SSH_KEY="${NEW_ADMIN_SSH_KEY:-}" 
    ALLOW_WEB="${ALLOW_WEB_TRAFFIC:-Y}"
  fi

  NEW_USER="${NEW_USER,,}"
  SSH_PORT="${SSH_PORT}"
  ensure_valid_port "$SSH_PORT"
  if [[ -z "$NEW_USER" ]]; then
    fatal "Username cannot be empty."
  fi
  if [[ -z "$SSH_KEY" ]]; then
    log "No SSH key supplied. You can add one later to /home/${NEW_USER}/.ssh/authorized_keys."
  fi

  ALLOW_WEB="${ALLOW_WEB,,}"
  if [[ -z "$ALLOW_WEB" ]]; then
    ALLOW_WEB="y"
  fi
}

update_system() {
  log "Refreshing apt metadata and installing baseline packages..."
  apt-get update -y
  apt-get -o Dpkg::Use-Pty=0 dist-upgrade -y
  apt-get install -y --no-install-recommends \
    ca-certificates curl git ufw fail2ban unattended-upgrades apt-listchanges needrestart
  apt-get autoremove -y
  apt-get clean
}

ensure_group() {
  local group_name="$1"
  if ! getent group "$group_name" > /dev/null; then
    log "Creating group '$group_name'."
    groupadd --system "$group_name"
  fi
}

create_admin_user() {
  log "Creating or updating privileged user '${NEW_USER}'."
  if id "$NEW_USER" > /dev/null 2>&1; then
    log "User ${NEW_USER} already exists; ensuring correct group membership."
  else
    adduser --disabled-password --gecos "" "$NEW_USER"
  fi
  usermod -aG sudo "$NEW_USER"
  ensure_group "sshusers"
  usermod -aG sshusers "$NEW_USER"

  if [[ -n "$SSH_KEY" ]]; then
    local user_home
    user_home=$(eval echo "~${NEW_USER}")
    mkdir -p "$user_home/.ssh"
    chmod 700 "$user_home/.ssh"
    local auth_keys="$user_home/.ssh/authorized_keys"
    touch "$auth_keys"
    chmod 600 "$auth_keys"
    if ! grep -qxF "$SSH_KEY" "$auth_keys"; then
      printf '%s\n' "$SSH_KEY" >> "$auth_keys"
    fi
    chown -R "$NEW_USER:$NEW_USER" "$user_home/.ssh"
    log "Authorised key installed for ${NEW_USER}."
  fi
}

lock_root_account() {
  log "Locking the root account password to prevent direct logins."
  passwd -l root >/dev/null 2>&1 || true
}

harden_sshd() {
  log "Applying SSH hardening and switching to port ${SSH_PORT}."
  local config_file="/etc/ssh/sshd_config.d/50-security-bootstrap.conf"
  cat > "$config_file" <<EOF
# Managed by Security-bashes/harden-ubuntu-vps.sh
Port ${SSH_PORT}
Protocol 2
PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
KbdInteractiveAuthentication no
PubkeyAuthentication yes
AuthenticationMethods publickey
X11Forwarding no
AllowGroups sshusers sudo
ClientAliveInterval 300
ClientAliveCountMax 2
LoginGraceTime 30
MaxAuthTries 3
AuthorizedKeysFile      .ssh/authorized_keys
EOF
  systemctl restart ssh
}

configure_firewall() {
  log "Configuring UFW firewall..."
  ufw --force disable >/dev/null 2>&1 || true
  ufw --force reset >/dev/null 2>&1 || true
  ufw default deny incoming
  ufw default allow outgoing
  ufw limit "${SSH_PORT}/tcp"
  if [[ "$ALLOW_WEB" == "y" || "$ALLOW_WEB" == "yes" ]]; then
    ufw allow 80/tcp
    ufw allow 443/tcp
  fi
  ufw logging medium
  ufw --force enable
}

configure_fail2ban() {
  log "Configuring Fail2Ban for SSH protection."
  local jail_file="/etc/fail2ban/jail.d/sshd.local"
  cat > "$jail_file" <<EOF
[sshd]
enabled = true
port = ${SSH_PORT}
filter = sshd
action = %(action_)s
backend = systemd
maxretry = 5
findtime = 600
bantime = 3600
ignoreip = 127.0.0.1/8 ::1
EOF
  systemctl enable --now fail2ban
  systemctl restart fail2ban
}

configure_unattended_upgrades() {
  log "Enabling unattended security updates."
  cat > /etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::Verbose "1";
EOF

  cat > /etc/apt/apt.conf.d/51unattended-upgrades-custom <<'EOF'
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "03:45";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
EOF
  systemctl enable --now unattended-upgrades
}

apply_sysctl_hardening() {
  log "Applying lightweight kernel network hardening."
  cat > /etc/sysctl.d/99-vps-security.conf <<'EOF'
net.ipv4.ip_forward = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0
net.ipv6.conf.all.disable_ipv6 = 0
kernel.kptr_restrict = 1
kernel.dmesg_restrict = 1
EOF
  sysctl -q -p /etc/sysctl.d/99-vps-security.conf
}

print_summary() {
  log "All tasks completed. Key reminders:"
  printf '\n - Test a new SSH session on port %s before closing your current one.\n' "$SSH_PORT"
  printf ' - Primary admin user: %s (member of sudo + sshusers).\n' "$NEW_USER"
  printf ' - Firewall: default deny incoming; SSH %s, HTTP/HTTPS allowed: %s.\n' "$SSH_PORT" "$ALLOW_WEB"
  printf ' - Fail2Ban + unattended upgrades now active.\n'
}

main() {
  require_root
  setup_variables
  update_system
  create_admin_user
  lock_root_account
  harden_sshd
  configure_firewall
  configure_fail2ban
  configure_unattended_upgrades
  apply_sysctl_hardening
  print_summary
}

main "$@"
