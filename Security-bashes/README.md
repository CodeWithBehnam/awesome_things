# Harden Ubuntu VPS Script Guide

This guide explains exactly what `Security-bashes/harden-ubuntu-vps.sh` does so you can audit and run it confidently on a fresh Ubuntu server. The script is designed for first-run hardening: it patches the OS, creates a locked-down admin pathway, enables firewalls and intrusion protection, and configures unattended updates following Ubuntu’s security recommendations ([Ubuntu security guide](https://ubuntu.com/server/docs/security)).

## Overview

- **Purpose:** Automate the minimum secure baseline for a public-facing VPS before deploying workloads.
- **Scope:** Ubuntu 20.04/22.04/24.04 LTS images with `apt`, `systemd`, and OpenSSH server installed.
- **Outcomes:** Hardened SSH, enforced public-key auth, sudo-capable non-root user, UFW + Fail2Ban, unattended security updates, and kernel-level network hardening.

## Prerequisites

- Run as `root` (e.g. `sudo -i`) on a clean Ubuntu VPS with outbound internet access.
- Copy an SSH public key for your admin user. Password logins are disabled after the script runs.
- Ensure you can keep the current SSH session open while testing the new port to avoid being locked out.

## Quick Start

```bash
# Copy the script to the server (example)
scp Security-bashes/harden-ubuntu-vps.sh root@server:/root/

# Run as root on the VPS
sudo bash /root/harden-ubuntu-vps.sh
```

The script prompts for the privileged username, SSH port, whether to allow HTTP/HTTPS, and a public key. You can also predefine these values with environment variables (see below) to run the script non-interactively.

## Configurable Inputs

| Variable | Prompt | Default | Description |
| --- | --- | --- | --- |
| `NEW_ADMIN_USER` | “Enter the name for the privileged user” | `deploy` | Name of the sudo-enabled non-root account added to both `sudo` and `sshusers` groups. |
| `NEW_ADMIN_SSH_KEY` | “Paste an SSH public key…” | _(empty)_ | Public key written to `/home/<user>/.ssh/authorized_keys`. Leave blank to add keys later. |
| `HARDENED_SSH_PORT` | “SSH port to allow” | `22` | TCP port configured for SSHD, UFW, and Fail2Ban. Must be 1–65535. |
| `ALLOW_WEB_TRAFFIC` | “Allow HTTP/HTTPS traffic?” | `Y` | Accepts `Y/es` or `N/o`. When yes, UFW opens ports 80 and 443. |

Run non-interactive by exporting the variables before invoking the script:

```bash
export NEW_ADMIN_USER=ops
export NEW_ADMIN_SSH_KEY="ssh-ed25519 AAAA..."
export HARDENED_SSH_PORT=2222
export ALLOW_WEB_TRAFFIC=N
sudo bash /root/harden-ubuntu-vps.sh
```

## What the Script Does

### 1. System Updates & Tooling (lines 74–81)
- Refreshes `apt` metadata, runs `dist-upgrade`, and installs baseline packages: `ufw`, `fail2ban`, `unattended-upgrades`, `needrestart`, `apt-listchanges`, etc.
- Cleans up obsolete packages to minimise the attack surface.

### 2. Admin User Creation (lines 91–116)
- Adds (or normalises) the chosen non-root user, joins it to `sudo` and a dedicated `sshusers` group, and enforces secure `.ssh` permissions before appending the supplied public key.
- Leaves a log reminder if no key is provided so you can add one manually.

### 3. Lock Root Password (lines 118–121)
- Runs `passwd -l root` so the root account cannot authenticate with a password, matching CIS and Ubuntu hardening advice ([Ubuntu security guide](https://ubuntu.com/server/docs/security-hardening)).

### 4. SSH Hardening (lines 123–145)
- Writes `/etc/ssh/sshd_config.d/50-security-bootstrap.conf` to:
  - Move SSH to the requested port.
  - Disable root login, password auth, challenge-response, and keyboard-interactive auth.
  - Require public-key authentication and limit auth attempts.
  - Restrict logins to the `sshusers` and `sudo` groups.
- Restarts the SSH service so changes take effect. These settings align with OpenSSH best practices ([OpenSSH hardening reference](https://www.ssh.com/academy/ssh/sshd_config)).

### 5. UFW Firewall Baseline (lines 147–160)
- Resets UFW, sets default deny inbound / allow outbound, rate-limits the SSH port, and optionally permits ports 80/443.
- Enables logging at `medium` and activates the firewall in one pass ([UFW docs](https://help.ubuntu.com/community/UFW)).

### 6. Fail2Ban (lines 162–179)
- Creates `/etc/fail2ban/jail.d/sshd.local` tuned to the chosen SSH port, enabling the jail with the default `action_mwl` profile (ban + email/log) to block brute-force attempts ([Fail2Ban documentation](https://www.fail2ban.org/wiki/index.php/Main_Page)).
- Enables and restarts the service so bans persist after reboots.

### 7. Unattended Upgrades (lines 181–197)
- Configures automatic security updates, daily metadata refresh, weekly autoclean, and automatic reboots at 03:45 if required.
- Ensures the `unattended-upgrades` service starts immediately ([Unattended Upgrades guide](https://wiki.debian.org/UnattendedUpgrades)).

### 8. Kernel & Network Hardening (lines 199–217)
- Writes `/etc/sysctl.d/99-vps-security.conf` to disable IP forwarding, drop source-route and ICMP redirect handling, enable martian logging, and restrict kernel pointer/dmesg exposure—lightweight defences recommended for general-purpose VPS workloads ([Linux kernel hardening notes](https://www.kernel.org/doc/html/latest/admin-guide/sysctl/net.html)).
- Applies the settings instantly via `sysctl -p`.

### 9. Final Summary (lines 219–225)
- Prints reminders: test the new SSH port before closing your session, note the admin user, check firewall allowances, and confirm Fail2Ban/unattended upgrades are active.

## Post-Run Verification Checklist

1. **Parallel SSH test:** From a second terminal, `ssh -p <port> <user>@<server>` to ensure the new port and key work before ending the original session.
2. **Firewall status:** `sudo ufw status verbose`.
3. **Fail2Ban health:** `sudo fail2ban-client status sshd`.
4. **Automatic updates:** `sudo systemctl status unattended-upgrades` and review `/var/log/unattended-upgrades/`.
5. **Sysctl values:** `sudo sysctl -a | grep -E 'accept_redirects|kptr_restrict|dmesg_restrict'`.

## Troubleshooting

- **Locked out after restart:** Use console access from your VPS provider to revert `/etc/ssh/sshd_config.d/50-security-bootstrap.conf`, then rerun the script with the correct key/port.
- **Fail2Ban not banning:** Confirm `/var/log/auth.log` exists and systemd backend is logging SSH events; adjust `logpath` if you use a custom syslog stack.
- **Need HTTP/HTTPS later:** Run `sudo ufw allow 80/tcp` and/or `sudo ufw allow 443/tcp` (or re-run the script with `ALLOW_WEB_TRAFFIC=Y`).
- **Different service ports:** After changing `HARDENED_SSH_PORT`, re-open the firewall port manually before restarting `sshd` to avoid being locked out.

## Suggested Extensions

1. Add CIS- or DISA-aligned auditing (e.g. `lynis`, `auditd`) if compliance evidence is required.
2. Integrate automatic malware scanning (e.g. `clamav`, `rkhunter`) for regulated workloads.
3. Bake the script into a cloud-init user data block or Packer template for repeatable provisioning.
4. Pair with GitHub Actions or n8n automations to push configuration state and alerts back to your preferred monitoring stack.

By following this guide you know exactly how `harden-ubuntu-vps.sh` modifies your server, which knobs you can tweak, and how to verify its protections stay in place over time.
