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

hUGETracker (macOS)

brew install samu/tools/hugetracker
ln -sf "$(brew --prefix)/opt/hugetracker/hUGETracker.app" /Applications/

The official macOS build is Intel-only, so the formula builds a native one from
the release tag instead (about two minutes). Homebrew has no Lazarus, so it
builds lazbuild from a pinned Lazarus 3.8 source tarball for this build only,
then builds the app and the uge2source converter with Homebrew's fpc. Built
locally, the app is not quarantined, so Gatekeeper does not block it. It links
Homebrew's SDL2, and runs Homebrew's rgbds and ffmpeg for ROM export and song
rendering. Formulae cannot install into /Applications, hence the symlink.

Three build fixes are applied: SDL2 is linked from Homebrew instead of a static
/usr/local build; the app links with a 10.15 deployment target because the
current Apple linker rejects FPC 3.2.2's Objective-C method lists otherwise
(https://gitlab.com/freepascal.org/fpc/source/-/issues/41868); and the .sym
parser skips the constants rgbds 1.0 adds to symbol files, which crashed it.

The example songs are under Help > Example Songs. On first launch hUGETracker
copies its font to ~/Library/Fonts and asks to be restarted; settings live in
~/.config/hUGETracker. The FamiTracker keymap is in
$(brew --prefix)/share/hugetracker/Keymaps.

.github/workflows/update-hugetracker.yml checks the latest stable GitHub release
daily and can also be run manually. It resolves the release tag to its commit
and commits tag/revision changes to the default branch. It does not build the
new release, so run brew upgrade soon after a bump to catch build breaks.

Furnace (macOS)

brew install --cask samu/tools/furnace

Installs the official Apple Silicon or Intel build, which is ad-hoc signed and
not notarized. SHA256 verification and macOS Gatekeeper remain in place. If
macOS blocks the app, review it and use System Settings > Privacy & Security >
Open Anyway only if you trust the release. The furnace command runs the same
binary for command-line rendering and export (furnace -help); Gatekeeper kills
it until the app has been opened and approved once. The demos,
instruments, wavetables and manual.pdf from the DMG stay in
$(brew --prefix)/Caskroom/furnace/<version>.

.github/workflows/update-furnace.yml checks the latest stable GitHub release
daily and can also be run manually. It downloads both macOS DMGs, computes their
SHA256s, and commits version/checksum changes to the default branch.

Edit fork (macOS)

brew unlink msedit
brew install --HEAD samu/tools/edit-fork

Builds Microsoft Edit from the main branch of github.com/scristobal/edit with
Homebrew's rust. There is no stable version, so --HEAD is required. It
conflicts with homebrew-core's msedit because both install an edit binary;
unlink msedit first, or brew link msedit again after uninstalling edit-fork.
To rebuild from the latest commit on the fork:
brew upgrade --fetch-HEAD edit-fork

Rust tools from crates.io

brew install samu/tools/build-pbf-glyphs
brew install samu/tools/cargo-aoc
brew install samu/tools/cargo-ndk
brew install samu/tools/cargo-swift
brew install samu/tools/shader-language-server

Each formula builds the published .crate from crates.io with Homebrew's rust,
using the Cargo.lock shipped inside it. .github/workflows/update-<formula>.yml
checks crates.io daily for the latest stable version and can also be run
manually. It downloads the .crate, computes its SHA256, and commits url/checksum
changes to the default branch.

cargo-tree-tui

brew install --HEAD samu/tools/cargo-tree-tui

Upstream (github.com/orhun/cargo-tree-tui) has no releases, tags or crates.io
package, so the formula only builds the latest commit on main. To rebuild:
brew upgrade --fetch-HEAD cargo-tree-tui
