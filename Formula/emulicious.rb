class Emulicious < Formula
  desc "Emulator and debugger for Game Boy, Master System, Game Gear and MSX"
  homepage "https://emulicious.net/"
  # Unversioned download; .github/workflows/update-emulicious.yml tracks its version and checksum.
  url "https://emulicious.net/download/emulicious/?wpdmdl=205"
  version "2026-03-27"
  sha256 "6e1c6d511014033bbc2668360a0194389a5bad2bf6c5ffd0fe093b84da33c0fc"
  license :cannot_represent

  livecheck do
    skip "No versioned download or release feed"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"] - %w[Emulicious.exe Emulicious.icl]
    # Without a license in prefix, Homebrew moves it out of libexec, but it must
    # ship with every copy of Emulicious.
    prefix.install_symlink libexec/"License.txt"

    # Emulicious stores settings, saves and save states next to its jar, so run a
    # per-user copy; the Cellar copy is replaced on every upgrade.
    (bin/"emulicious").write <<~SH
      #!/bin/bash
      set -euo pipefail
      app_home="$HOME/Library/Application Support/Emulicious"
      if ! cmp -s "#{libexec}/Emulicious.jar" "$app_home/Emulicious.jar"; then
        mkdir -p "$app_home"
        cp -R "#{libexec}/." "$app_home/"
      fi
      exec "#{formula_opt_bin("openjdk")}/java" -Xdock:name=Emulicious -jar "$app_home/Emulicious.jar" "$@"
    SH
  end

  def caveats
    <<~EOS
      Emulicious runs from a per-user copy that also keeps its settings, saves
      and save states:
        ~/Library/Application Support/Emulicious
      Update it with brew upgrade rather than its built-in updater.
    EOS
  end

  test do
    # Without a display Emulicious stops once it tries to open its window.
    ENV["JAVA_TOOL_OPTIONS"] = "-Djava.awt.headless=true"
    (testpath/"test.gb").write "\0" * 32768
    output = shell_output("#{bin}/emulicious -disassemble test.gb 2>&1", 1)
    assert_match "platform.Emulicious.main", output
    assert_path_exists testpath/"Library/Application Support/Emulicious/Emulicious.jar"
  end
end
