# Security Policy

## Supported Versions

We release security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| main    | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security issue, please follow these steps:

### 1. Do NOT Disclose Publicly

Please do not open a public GitHub issue for security vulnerabilities. This helps protect users while we work on a fix.

### 2. Report Privately

Send details to the project maintainers via:

- **Email**: [Create a private security advisory on GitHub]
- **GitHub Security Advisory**: Use the "Report a vulnerability" button in the Security tab

### 3. Provide Details

Include the following information in your report:

- **Description**: Clear description of the vulnerability
- **Impact**: What can be achieved by exploiting this vulnerability
- **Steps to Reproduce**: Detailed steps to reproduce the issue
- **Affected Components**: Which parts of the system are affected
- **Suggested Fix**: If you have ideas for remediation
- **Proof of Concept**: Code or screenshots demonstrating the issue (if applicable)

### 4. Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Fix Timeline**: Depends on severity (see below)

## Severity Levels

We use the following severity classifications:

### Critical (Fix within 24-48 hours)

- Remote code execution
- SQL injection
- Authentication bypass
- Privilege escalation
- Data breach potential

### High (Fix within 7 days)

- XSS vulnerabilities
- CSRF vulnerabilities
- Sensitive data exposure
- Security misconfiguration

### Medium (Fix within 30 days)

- Denial of Service
- Information disclosure
- Weak cryptography

### Low (Fix within 90 days)

- Missing security headers
- Outdated dependencies
- Minor security enhancements

## Security Best Practices

### For Contributors

1. **Never commit sensitive data**
   - API keys, passwords, tokens
   - Use `.env` files (git-ignored)
   - Use environment variables

2. **Input Validation**
   - Validate all user inputs
   - Sanitize data before database queries
   - Use parameterized queries

3. **Authentication & Authorization**
   - Use bcrypt for password hashing
   - Implement proper JWT validation
   - Follow principle of least privilege

4. **Dependencies**
   - Keep dependencies up to date
   - Run `npm audit` regularly
   - Review security advisories

5. **Code Review**
   - Review all PRs for security issues
   - Use static analysis tools
   - Test authentication/authorization flows

### For Deployments

1. **Environment Variables**
   ```bash
   # Required environment variables
   MONGODB_URI=<secure-connection-string>
   JWT_SECRET=<strong-random-secret>
   JWT_REFRESH_SECRET=<strong-random-secret>
   GOOGLE_AI_API_KEY=<your-api-key>
   RESEND_API_KEY=<your-api-key>
   ```

2. **Database Security**
   - Use MongoDB Atlas or secure MongoDB installation
   - Enable authentication
   - Use encrypted connections (TLS/SSL)
   - Implement proper access controls
   - Regular backups

3. **API Security**
   - Enable CORS with specific origins
   - Implement rate limiting
   - Use HTTPS in production
   - Set security headers:
     ```javascript
     helmet({
       contentSecurityPolicy: true,
       xssFilter: true,
       noSniff: true,
       hsts: true
     })
     ```

4. **Redis Security**
   - Enable password authentication
   - Bind to localhost or private network
   - Use encrypted connections

5. **Docker Security**
   - Don't run containers as root
   - Use official base images
   - Scan images for vulnerabilities
   - Keep images updated

## Known Security Considerations

### JWT Tokens

- Access tokens expire in 1 hour
- Refresh tokens expire in 7 days
- Stored in HTTP-only cookies
- CSRF protection recommended for production

### File Uploads

Currently, the application does not support file uploads. If this feature is added:
- Validate file types
- Scan for malware
- Limit file sizes
- Store outside web root

### Third-Party APIs

The application integrates with:
- **Google Generative AI** (Gemini): For content summarization
- **NewsAPI**: For article fetching
- **Resend**: For email delivery

Ensure API keys are:
- Stored securely in environment variables
- Never committed to version control
- Rotated regularly
- Scoped with minimal permissions

### Web Scraping

The crawler accesses external websites:
- Respect robots.txt
- Implement rate limiting
- Handle errors gracefully
- Validate scraped content before storage

## Security Checklist

Before deploying to production:

- [ ] All environment variables are set securely
- [ ] Database has authentication enabled
- [ ] HTTPS is enabled
- [ ] Security headers are configured
- [ ] Rate limiting is enabled
- [ ] CORS is configured with specific origins
- [ ] JWT secrets are strong and unique
- [ ] Dependencies are up to date
- [ ] `npm audit` shows no vulnerabilities
- [ ] Error messages don't leak sensitive information
- [ ] Logging doesn't include sensitive data
- [ ] Backup and recovery procedures are tested
- [ ] Input validation is comprehensive
- [ ] SQL injection protection is in place
- [ ] XSS protection is enabled
- [ ] CSRF protection is configured

## Common Vulnerabilities

### Preventing SQL Injection

```typescript
// ✅ GOOD - Using Mongoose (parameterized)
await User.findOne({ email: userEmail });

// ❌ BAD - String concatenation
await User.findOne(`{ email: "${userEmail}" }`);
```

### Preventing XSS

```typescript
// ✅ GOOD - React auto-escapes
<div>{userInput}</div>

// ❌ BAD - Using dangerouslySetInnerHTML without sanitization
<div dangerouslySetInnerHTML={{ __html: userInput }} />

// ✅ GOOD - Sanitized HTML
import DOMPurify from 'dompurify';
<div dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(userInput) }} />
```

### Preventing Authentication Bypass

```typescript
// ✅ GOOD - Verify JWT on every protected route
app.use('/api/protected', authenticateToken);

// ✅ GOOD - Check user permissions
if (req.user.id !== articleOwnerId) {
  return res.status(403).json({ error: 'Forbidden' });
}
```

### Secure Password Handling

```typescript
// ✅ GOOD - Using bcrypt with proper rounds
const hashedPassword = await bcrypt.hash(password, 10);

// ❌ BAD - Storing plain text passwords
user.password = password; // Never do this!
```

## Security Tools

### Recommended Tools

1. **npm audit**: Check for vulnerable dependencies
   ```bash
   npm audit
   npm audit fix
   ```

2. **Snyk**: Continuous security monitoring
   ```bash
   npx snyk test
   ```

3. **OWASP Dependency-Check**: Identify known vulnerabilities
   ```bash
   dependency-check --project "AI Content Curator" --scan .
   ```

4. **ESLint Security Plugin**: Static analysis
   ```bash
   npm install --save-dev eslint-plugin-security
   ```

5. **SonarQube**: Code quality and security
   ```bash
   sonar-scanner
   ```

## Disclosure Policy

When a security vulnerability is fixed:

1. We will release a patch as soon as possible
2. We will publish a security advisory
3. We will credit the reporter (unless they prefer to remain anonymous)
4. We will document the vulnerability in the changelog

## Hall of Fame

We appreciate security researchers who help keep our project secure. Contributors who responsibly disclose vulnerabilities will be listed here (with permission):

- *No vulnerabilities reported yet*

## Contact

For security concerns, contact the maintainers:

- **GitHub Security Advisory**: Preferred method
- **Email**: Use the email addresses in the repository maintainer profiles

## Additional Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
- [Node.js Security Best Practices](https://nodejs.org/en/docs/guides/security/)
- [MongoDB Security Checklist](https://docs.mongodb.com/manual/administration/security-checklist/)
- [JWT Best Practices](https://tools.ietf.org/html/rfc8725)

---

**Last Updated**: 2025-11-13

Thank you for helping keep AI Content Curator secure!
