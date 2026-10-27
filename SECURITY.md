# Security Policy

This policy applies to all repositories in the [open-security-tooling](https://github.com/open-security-tooling) organization unless a repository provides its own `SECURITY.md`.

## Reporting a vulnerability

**Please do not report security vulnerabilities through public issues, discussions, or pull requests.**

Report them privately using GitHub's private vulnerability reporting:

1. Go to the affected repository's **Security** tab.
2. Click **Report a vulnerability**.

Or go directly to `https://github.com/open-security-tooling/<repository>/security/advisories/new`.

Please include as much of the following as you can:

- The affected repository, version, or commit
- A description of the issue and its impact
- Steps to reproduce, or a proof of concept
- Any known mitigations or workarounds

## What to expect

These projects are maintained on a best-effort basis, so we can't promise fixed response times, but we take every report seriously.

- We'll acknowledge your report, assess it, and keep you updated through the private advisory.
- We'll coordinate disclosure with you and publish a GitHub security advisory once a fix is available.
- With your permission, we'll credit you in the advisory.

## Supported versions

Unless a repository states otherwise, only the **latest release** receives security fixes.

## Scope

In scope: vulnerabilities in the code, build, release, or CI/CD of our repositories, such as code execution, credential exposure, or supply-chain compromise.

Out of scope: false positives or negatives in a tool's *detection results*. Please report those as regular issues.
