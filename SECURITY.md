# Security Policy

## Supported Versions

Security fixes are considered for the current default branch and the latest
published release, if one exists. Older branches, tags, or forks may not receive
security updates unless maintainers explicitly say otherwise in the repository.

## Reporting a Vulnerability

Please do not disclose vulnerability details in a public issue, pull request, or
discussion.

If GitHub private vulnerability reporting or Security Advisories are enabled for
this repository, use that feature to report the issue privately. If no private
reporting option is available, open a minimal public issue asking maintainers to
provide a private reporting channel. Do not include exploit details, secrets,
proof-of-concept code, affected tokens, or sensitive logs in that public issue.

When reporting privately, include:

- Affected version, branch, commit, or release.
- A clear description of the vulnerability and its impact.
- Steps to reproduce, proof-of-concept details, or relevant logs with secrets
  removed.
- Any known workarounds or mitigations.
- Whether the issue is being actively exploited or is time-sensitive.

## Secret Handling

Do not send real tokens, passwords, private keys, cookies, session data, or other
secrets. Redact sensitive values before sharing logs or configuration. If a
secret may have been exposed, rotate it before submitting the report and mention
that rotation was completed.

## Responsible Disclosure

Please allow maintainers a reasonable time to investigate and prepare a fix
before public disclosure. Avoid accessing, modifying, deleting, or exfiltrating
data that does not belong to you. Keep testing limited to the minimum needed to
confirm the issue, and coordinate disclosure timing with maintainers when
possible.
