# Learny Technologies Homebrew Tap

This tap contains public installation metadata only. Learny product code and release artifacts stay
private in their source repositories.

## Control Plane CLI

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
