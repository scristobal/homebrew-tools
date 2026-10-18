cask "ldtk" do
  version "1.5.3"
  sha256 "d8f8ab8f7e2001a64d7db04eac8d68ec305fd21d3404a2d40d9e0377aa5dac62"

  # The zip holds a single installer DMG, which Homebrew extracts automatically.
  url "https://github.com/deepnight/ldtk/releases/download/v#{version}/mac-distribution.zip"
  name "LDtk"
  name "Level Designer Toolkit"
  desc "Modern 2D level editor"
  homepage "https://ldtk.io/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "LDtk.app"

  zap trash: [
    "~/Library/Application Support/LDtk",
    "~/Library/Caches/ldtk-updater",
    "~/Library/Logs/LDtk",
    "~/Library/Preferences/com.deepnight.ldtk.plist",
    "~/Library/Saved Application State/com.deepnight.ldtk.savedState",
  ]
end
