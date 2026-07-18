# Learny Technologies Homebrew Tap

This tap contains public installation metadata only. Learny product code and release artifacts stay
private in their source repositories.

## Control Plane CLI

The recommended developer-Mac installation is the [`gh-controlpctl` GitHub CLI
extension](https://github.com/learny-technologies/gh-controlpctl). It uses the existing
Keychain-backed `gh auth login` session directly, without passing a token to another process:

```bash
gh extension install learny-technologies/gh-controlpctl
gh controlpctl install
```

The Homebrew formula below remains available for managed-machine workflows. Homebrew's sandbox
cannot access the macOS Keychain session used by `gh`, so it requires an explicit one-command token
handoff.

Authenticate GitHub CLI once with an organization account that can read the private Control Plane
repository:

```bash
gh auth login
```

Install or update the CLI in one command. The command derives a short-lived process environment
value from the Keychain-backed GitHub CLI session; it does not write the token to the shell profile,
tap, or Homebrew configuration:

```bash
HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)" \
  brew install learny-technologies/tap/controlpctl

HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)" \
  brew upgrade controlpctl
```

The formula uses `gh release download` to obtain the exact private release wheel, verifies its
pinned SHA-256 digest, and installs it in an isolated Python environment. No GitHub token is stored
in this repository or Homebrew configuration.
