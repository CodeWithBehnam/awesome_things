# Security Audit

Perform a comprehensive security review of the codebase.

## Purpose
Identify security vulnerabilities, assess security posture, and provide recommendations to improve application security.

## Instructions
1. **Vulnerability Assessment**:
   - Check for OWASP Top 10 vulnerabilities
   - Review authentication and authorization mechanisms
   - Analyse data handling and validation processes
   - Check for sensitive data exposure and logging
   - Assess input validation and sanitisation

2. **Code Security Review**:
   - **Input Validation**: Review all user inputs for proper validation and sanitisation
   - **Authentication**: Check password policies, session management, and multi-factor authentication
   - **Authorization**: Verify proper access controls and permission checks
   - **Data Protection**: Review encryption, data storage, and transmission security
   - **Error Handling**: Check for information disclosure in error messages

3. **Common Security Issues**:
   - **SQL Injection**: Review database queries and parameter binding
   - **XSS (Cross-Site Scripting)**: Check output encoding and CSP headers
   - **CSRF (Cross-Site Request Forgery)**: Verify CSRF protection mechanisms
   - **Insecure Direct Object References**: Review access control for resources
   - **Security Misconfiguration**: Check default configurations and unnecessary features

4. **Security Best Practices**:
   - Implement proper error handling without information disclosure
   - Use secure coding practices and libraries
   - Implement proper logging and monitoring
   - Follow principle of least privilege
   - Implement defense in depth strategies

5. **Recommendations and Remediation**:
   - Provide specific security improvements with code examples
   - Suggest security tools and libraries
   - Create security checklist for future development
   - Recommend security testing and monitoring tools
   - Provide remediation timeline and priority levels

## Examples
- **Audit API endpoints**: `/security-audit` on API route files
- **Audit authentication**: `/security-audit` on authentication middleware
- **Audit data handling**: `/security-audit` on data processing code
- **Audit frontend security**: `/security-audit` on client-side code

## Constraints
- Focus on practical, actionable security improvements
- Consider the application's threat model and risk profile
- Balance security with usability and performance
- Provide specific code examples for security fixes
- Prioritise critical and high-severity vulnerabilities