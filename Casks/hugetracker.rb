cask "hugetracker" do
  version "1.0.11"
  sha256 "00c42903bf5fb7cd9302c12c0a66a6cfff51a743984bc1cc15ef758ec1ea95bc"

  # Casks must download something, so take the release's source; the app itself
  # is built by Formula/hugetracker.rb.
  url "https://github.com/SuperDisk/hUGETracker/archive/refs/tags/v#{version}.tar.gz"
  name "hUGETracker"
  desc "Music tracker for the Game Boy"
  homepage "https://nickfa.ro/wiki/hUGETracker"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on formula: "samu/tools/hugetracker"
  depends_on :macos

  app "hUGETracker.app"

  # Copy rather than link the formula's app so Spotlight and Launchpad treat it
  # like any other app in /Applications.
  preflight_steps do
    copy "opt/hugetracker/hUGETracker.app", "hUGETracker.app", source_base: :homebrew_prefix, recursive: true
  end

  zap trash: [
    "~/.cache/hUGETracker",
    "~/.config/hUGETracker",
    "~/Library/Fonts/Pixelite.ttf",
    "~/Library/Preferences/com.company.hUGETracker.plist",
    "~/Library/Saved Application State/com.company.hUGETracker.savedState",
  ]

  caveats <<~EOS
    /Applications/hUGETracker.app is a copy of the hugetracker formula's build.
    If you reinstall only the formula, reinstall the cask too:
      brew reinstall --cask samu/tools/hugetracker
    On first launch hUGETracker copies its font to ~/Library/Fonts and asks to
    be restarted.
  EOS
end
