brew tap samu/tools https://github.com/scristobal/homebrew-tools
brew install samu/tools/copilot-language-server
brew install samu/tools/typescript-language-server
brew install samu/tools/cspell-lsp

Alacritty (macOS)

brew install --cask samu/tools/alacritty

This cask uses official Alacritty releases but omits Homebrew's disable rule
for missing notarization. SHA256 verification and macOS Gatekeeper remain
in place. If macOS blocks the app, review it and use System Settings >
Privacy & Security > Open Anyway only if you trust the release.

To switch an existing Homebrew installation to this tap (without deleting settings):
brew uninstall --cask alacritty
brew install --cask samu/tools/alacritty

.github/workflows/update-alacritty.yml checks the latest stable GitHub release
daily and can also be run manually. It downloads the DMG, computes its SHA256,
and commits version/checksum changes to the default branch using GITHUB_TOKEN.
GitHub Actions must be enabled and allowed to push to that branch.

LDtk (macOS)

brew install --cask samu/tools/ldtk

The official macOS build is ad-hoc signed and not notarized. SHA256
verification and macOS Gatekeeper remain in place. If macOS blocks the app,
review it and use System Settings > Privacy & Security > Open Anyway only if
you trust the release. The app cannot update itself on macOS; use
brew upgrade --cask samu/tools/ldtk instead.

.github/workflows/update-ldtk.yml checks the latest stable GitHub release daily
and can also be run manually. It downloads mac-distribution.zip, checks that it
still contains a single installer DMG, computes its SHA256, and commits
version/checksum changes to the default branch using GITHUB_TOKEN.

GBDK-2020 (macOS)

brew install samu/tools/gbdk-2020

Installs the official prebuilt toolchain for Apple Silicon or Intel. lcc,
png2asset, romusage and GBDK's other own tools are linked onto PATH; its
bundled SDCC stays private so it does not clash with Homebrew's sdcc formula.
Makefiles from the GBDK examples work with:
export GBDK_HOME="$(brew --prefix gbdk-2020)/libexec"

.github/workflows/update-gbdk-2020.yml checks the latest stable GitHub release
daily and can also be run manually. It downloads both macOS tarballs, computes
their SHA256s, and commits version/checksum changes to the default branch.

Emulicious (macOS)

brew install --cask samu/tools/emulicious

Upstream only ships a cross-platform jar, so the cask wraps it in a minimal
Emulicious.app that runs it with Homebrew's openjdk; the emulicious command
starts the same app. Both run a per-user copy in
~/Library/Application Support/Emulicious, where Emulicious also stores its
settings, saves and save states, so they survive upgrades. Update it with
brew upgrade --cask rather than its built-in updater.

.github/workflows/update-emulicious.yml downloads the unversioned zip daily and
can also be run manually. It reads the release date from WhatsNew.txt, computes
the SHA256, and commits version/checksum changes to the default branch. Between
an upstream release and the next run, installs fail with a checksum mismatch;
run the workflow manually to catch up sooner.
