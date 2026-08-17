# Quotio Release Guide

## Automated Release

Use the GitHub **Release** workflow. It can be triggered from the Actions page with a version such as `1.2.3` or `1.2.3-beta-1`.

The workflow:

1. Updates `CHANGELOG.md` and the Xcode version.
2. Calls `scripts/build_dmg.sh` to archive the app and create DMG and ZIP artifacts.
3. Signs the ZIP and creates the Sparkle appcast.
4. Creates the tag and GitHub Release.
5. Commits the version and changelog changes back to the source branch.
6. Updates the Homebrew tap for stable releases.

The repository must have these GitHub Actions secrets:

| Name | Purpose |
|------|---------|
| `SPARKLE_PRIVATE_KEY` | Sparkle EdDSA signing key |
| `POSTHOG_PROJECT_TOKEN` | Optional PostHog project token embedded at build time |
| `TAP_TOKEN` | Dispatch the stable release to the Homebrew tap |

## Local Artifacts

Build the current project version without changing source files:

```bash
./scripts/build_dmg.sh
```

Artifacts are written to `build/release/`:

- `Quotio-<version>.dmg`
- `Quotio-<version>.zip`

Install `create-dmg` for the custom DMG layout; otherwise the script falls back to `hdiutil`:

```bash
brew install create-dmg
```

## Local Release Preparation

The same CI path can be exercised locally when a Sparkle private key is available:

```bash
SPARKLE_PRIVATE_KEY=... \
  ./scripts/build_dmg.sh --version 1.2.3 --generate-appcast
```

`--version` modifies `CHANGELOG.md` and `Quotio.xcodeproj/project.pbxproj`. `--generate-appcast` creates `build/release/appcast.xml`; it does not create a tag, push, or publish a GitHub Release.

Pre-release versions containing `alpha`, `beta`, or `rc` are added to the Sparkle beta channel.

## Verification

After a release:

- Download and open the DMG.
- Confirm the ZIP and `appcast.xml` are attached to the GitHub Release.
- Check stable and beta update channels as applicable.
