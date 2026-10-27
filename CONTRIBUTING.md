# Contributing

Thanks for helping out! This guide applies to all repositories in the organization unless a repository provides its own.

## Reporting security issues

Don't open public issues for vulnerabilities. Follow the [security policy](SECURITY.md) instead.

## Pull requests

1. Fork the repository and create a branch from `main`.
2. Keep changes focused. One logical change per PR is easiest to review.
3. Add or update tests where it makes sense.
4. Open a PR and fill in the template.

The `main` branch is protected: changes land through pull requests, and force-pushes are blocked.

## Signed commits are required

Every commit on `main` must have a verified signature. The simplest setup is SSH signing with a key you already use:

```sh
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
```

Then add the same public key to GitHub as a **Signing key** at <https://github.com/settings/ssh/new>. Your commit email must be a verified email on your GitHub account. Your GitHub noreply address works too.

Hardware keys such as a YubiKey work as well (`ssh-keygen -t ed25519-sk`). See GitHub's docs on [signing commits](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits).

Forgot to sign? Re-sign your branch with `git rebase --exec 'git commit --amend --no-edit -S' main`, then force-push your branch (not `main`).

## GitHub Actions

To reduce supply-chain risk:

- Only GitHub-owned and Marketplace verified-creator actions are allowed.
- Actions must be pinned to a **full commit SHA**, with the version as a comment:
  ```yaml
  - uses: actions/checkout@<full-40-char-sha> # v4.2.2
  ```
  Dependabot keeps these pins up to date.
- Workflows should declare the narrowest `permissions:` they need, starting from `permissions: {}`.

## License

By contributing, you agree that your contributions are licensed under the repository's license (Apache-2.0 unless stated otherwise).
