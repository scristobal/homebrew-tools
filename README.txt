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

