# Homebrew Apps

[![Test Casks](https://github.com/chenwei791129/homebrew-apps/actions/workflows/test-casks.yml/badge.svg)](https://github.com/chenwei791129/homebrew-apps/actions/workflows/test-casks.yml)

Homebrew Tap for [chenwei791129](https://github.com/chenwei791129) apps.

## Available Casks

| Cask | Description |
|------|-------------|
| [launchpal](https://github.com/chenwei791129/launchpal) | macOS LaunchAgent GUI management tool |

## Installation

```bash
brew install --cask chenwei791129/apps/launchpal
```

For Homebrew 6.0.0+ with tap trust enabled, installing with the fully-qualified
name above will trust this cask automatically.

If you installed it previously and want to ensure future upgrades are not
blocked by tap trust checks, run:

```bash
brew trust --cask chenwei791129/apps/launchpal
```

Or add the tap first:

```bash
brew tap chenwei791129/apps
brew install --cask launchpal
```

## CI

Any push or pull request that touches `Casks/*.rb` runs
[`test-casks.yml`](.github/workflows/test-casks.yml) on macOS with Homebrew 7:
`brew audit`, a verbose install, artifact and `com.apple.quarantine` checks, and
an uninstall/reinstall cycle. New casks need no workflow change — the job matrix
is built from the files in `Casks/`.
