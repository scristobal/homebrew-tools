class Hugetracker < Formula
  desc "Music tracker for the Game Boy"
  homepage "https://nickfa.ro/wiki/hUGETracker"
  # The git URL brings the hUGEDriver, SDL2 header, BGRABitmap and rackctls submodules.
  url "https://github.com/SuperDisk/hUGETracker.git",
      tag:      "v1.0.11",
      revision: "0623f3f7da0a8ac5b30b5f6aa92debd3db45efc5"
  license :public_domain

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "fpc" => :build
  depends_on "ffmpeg"
  depends_on :macos
  depends_on "rgbds"
  depends_on "sdl2-compat"

  # Homebrew has no Lazarus, so build lazbuild and the LCL inside this formula only.
  resource "lazarus" do
    url "https://gitlab.com/freepascal.org/lazarus/lazarus/-/archive/lazarus_3_8/lazarus-lazarus_3_8.tar.gz"
    sha256 "7e9720f2f2b218774238ce187a746a8227e6149252c59cd2d2597b91ac1c0bb2"
  end

  def install
    lazarus = buildpath/"lazarus"
    resource("lazarus").stage(lazarus)
    # The Lazarus makefiles race when run in parallel.
    ENV.deparallelize { system "make", "-C", lazarus, "lazbuild", "FPC=#{formula_opt_bin("fpc")}/fpc" }
    lazbuild = [lazarus/"lazbuild", "--lazarusdir=#{lazarus}", "--pcp=#{buildpath}/lazarus-config", "--ws=cocoa"]

    # Upstream links a static, audio-only SDL2 from /usr/local; use Homebrew's instead.
    inreplace "src/hUGETracker.lpr", "{$link /usr/local/lib/libSDL2.a}", "{$linklib SDL2}"
    inreplace "src/hUGETracker.lpi", '<Libraries Value="\usr\local\lib\"/>',
              "<Libraries Value=\"#{formula_opt_lib("sdl2-compat")}\"/>"
    # ld-prime rejects the Objective-C method lists FPC emits for the Cocoa LCL
    # unless chained fixups are off, which a 10.15 deployment target does:
    # https://gitlab.com/freepascal.org/fpc/source/-/issues/41868
    inreplace "src/hUGETracker.lpi",
              %r{(<Item4 Name="Production Mac">.*?<CustomOptions Value="-dPRODUCTION)"/>}m,
              '\1 -WM10.15"/>'
    # RGBDS 1.0's rgblink also lists constants in .sym files as "<value> <name>",
    # without the bank:address the tracker parses.
    inreplace "src/symparser.pas", "      SA := S.Split(' ');\n",
              "      SA := S.Split(' ');\n      if Pos(':', SA[0]) = 0 then Continue;\n"

    system(*lazbuild, "--add-package-link", "src/rackctls/RackCtlsPkg.lpk")
    system(*lazbuild, "--add-package-link", "src/bgrabitmap/bgrabitmap/bgrabitmappack.lpk")
    system(*lazbuild, "--build-mode=Production Mac", "src/hUGETracker.lpi")
    system(*lazbuild, "--build-mode=Release", "src/uge2source/uge2source.lpi")

    # The ROM the tracker plays songs through, built as upstream's release workflow does.
    system "rgbasm", "-E", "-I", "src/hUGEDriver", "-o", "hUGEDriver.obj", "src/hUGEDriver/hUGEDriver.asm"
    system "rgbasm", "-I", "src/hUGEDriver/include", "-o", "halt.obj", "src/halt.asm"
    system "rgblink", "-o", "halt.gb", "-n", "halt.sym", "halt.obj", "hUGEDriver.obj"
    system "rgbfix", "-vp0xFF", "halt.gb"

    contents = prefix/"hUGETracker.app/Contents"
    (contents/"MacOS").install "src/Release/hUGETracker"
    # The tracker runs these by name from its MacOS directory; apps opened from
    # Finder do not have Homebrew on PATH. Homebrew makes symlinks into its prefix
    # relative, which would break in the cask's copy in /Applications, so call
    # the opt paths from exec scripts instead.
    tools = %w[rgbasm rgblink rgbfix].map { |tool| formula_opt_bin("rgbds")/tool }
    tools << (formula_opt_bin("ffmpeg")/"ffmpeg")
    (contents/"MacOS").write_exec_script tools
    chmod 0755, tools.map { |tool| contents/"MacOS"/tool.basename }

    rm_r Dir["src/hUGEDriver/.git*"]
    (contents/"Resources").install "graphics/hUGETracker.icns", "fonts/PixeliteTTF.ttf",
                                   "halt.gb", "halt.sym", "src/hUGEDriver"
    (contents/"Resources/Sample Songs").install Dir["sample-songs/*.uge"]
    (contents/"Info.plist").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>hUGETracker</string>
        <key>CFBundleIconFile</key>
        <string>hUGETracker.icns</string>
        <key>CFBundleIdentifier</key>
        <string>com.company.hUGETracker</string>
        <key>CFBundleName</key>
        <string>hUGETracker</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>CFBundleShortVersionString</key>
        <string>#{version}</string>
        <key>NSHighResolutionCapable</key>
        <true/>
      </dict>
      </plist>
    XML

    bin.install "src/uge2source/Release/uge2source"
    pkgshare.install "keymaps" => "Keymaps"
  end

  def caveats
    <<~EOS
      hUGETracker.app was installed to:
        #{opt_prefix}/hUGETracker.app
      To copy it into /Applications, install the cask, which reinstalls the copy
      on every upgrade:
        brew install --cask samu/tools/hugetracker
    EOS
  end

  test do
    song = prefix/"hUGETracker.app/Contents/Resources/Sample Songs/Coffee Bat - Blue Ocean.uge"
    system bin/"uge2source", song, "blue_ocean", testpath/"blue_ocean.c"
    assert_match "blue_ocean", (testpath/"blue_ocean.c").read
  end
end
