cask "hugetracker" do
  version "1.0.11"
  sha256 "259a694fd93ae5f6c430e13ca7fcca0c86c83b7b2bfd50c38394cbdbd5f8a5d0"

  url "https://github.com/SuperDisk/hUGETracker/releases/download/v#{version}/hUGETracker-#{version}-mac.zip"
  name "hUGETracker"
  desc "Music tracker for the Game Boy"
  homepage "https://nickfa.ro/wiki/hUGETracker"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "hUGETracker.app"
  binary "uge2source"

  # The zip ships the sample songs next to the app, but File > Sample Songs only
  # lists the ones in its Resources directory.
  preflight_steps do
    move "Sample Songs", "hUGETracker.app/Contents/Resources/Sample Songs"
  end

  zap trash: [
    "~/.cache/hUGETracker",
    "~/.config/hUGETracker",
    "~/Library/Fonts/Pixelite.ttf",
    "~/Library/Preferences/com.company.hUGETracker.plist",
    "~/Library/Saved Application State/com.company.hUGETracker.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
