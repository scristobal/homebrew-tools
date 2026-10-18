cask "emulicious" do
  version "2026-03-27"
  sha256 "6e1c6d511014033bbc2668360a0194389a5bad2bf6c5ffd0fe093b84da33c0fc"

  # Unversioned download; .github/workflows/update-emulicious.yml tracks its version and checksum.
  url "https://emulicious.net/download/emulicious/?wpdmdl=205"
  name "Emulicious"
  desc "Emulator and debugger for Game Boy, Master System, Game Gear and MSX"
  homepage "https://emulicious.net/"

  livecheck do
    skip "No versioned download or release feed"
  end

  depends_on formula: "openjdk"
  depends_on :macos

  # Upstream only ships a cross-platform jar, so preflight_steps wrap it in a minimal app bundle.
  app "Emulicious.app"
  generated_script "Emulicious.app/Contents/MacOS/Emulicious", content: <<~SH
    #!/bin/bash
    set -euo pipefail
    contents="$(cd "$(dirname "$0")/.." && pwd)"
    # Emulicious stores settings, saves and save states next to its jar, so run a
    # per-user copy; this app is replaced on every upgrade.
    app_home="$HOME/Library/Application Support/Emulicious"
    if ! cmp -s "$contents/Resources/Java/Emulicious.jar" "$app_home/Emulicious.jar"; then
      mkdir -p "$app_home"
      cp -R "$contents/Resources/Java/." "$app_home/"
    fi
    exec "#{HOMEBREW_PREFIX}/opt/openjdk/bin/java" \\
      -Xdock:name=Emulicious -Xdock:icon="$contents/Resources/Emulicious.icns" \\
      -jar "$app_home/Emulicious.jar" "$@"
  SH
  command_wrapper "emulicious", executable: "#{appdir}/Emulicious.app/Contents/MacOS/Emulicious"

  preflight_steps do
    move_contents ".", "payload"
    remove ["payload/Emulicious.exe", "payload/Emulicious.icl"]
    mkdir_p "Emulicious.app/Contents/Resources"
    move "payload", "Emulicious.app/Contents/Resources/Java"
    run "/usr/bin/unzip",
        args: ["-q", "-j", "{{staged_path}}/Emulicious.app/Contents/Resources/Java/Emulicious.jar",
               "Emulicious.png", "-d", "{{staged_path}}/Emulicious.app/Contents/Resources"]
    run "/usr/bin/sips",
        args: ["-s", "format", "icns", "{{staged_path}}/Emulicious.app/Contents/Resources/Emulicious.png",
               "--out", "{{staged_path}}/Emulicious.app/Contents/Resources/Emulicious.icns"]
    remove "Emulicious.app/Contents/Resources/Emulicious.png"
    write_file "Emulicious.app/Contents/Info.plist", <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>Emulicious</string>
        <key>CFBundleIconFile</key>
        <string>Emulicious</string>
        <key>CFBundleIdentifier</key>
        <string>io.github.scristobal.emulicious</string>
        <key>CFBundleName</key>
        <string>Emulicious</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>CFBundleShortVersionString</key>
        <string>{{version}}</string>
        <key>NSHighResolutionCapable</key>
        <true/>
      </dict>
      </plist>
    XML
  end

  zap trash: "~/Library/Application Support/Emulicious"

  caveats <<~EOS
    Emulicious runs from a per-user copy that also keeps its settings, saves
    and save states:
      ~/Library/Application Support/Emulicious
    Update it with brew upgrade rather than its built-in updater.
  EOS
end
