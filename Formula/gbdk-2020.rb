class Gbdk2020 < Formula
  desc "C toolchain and libraries for Game Boy, NES, Master System and Game Gear"
  homepage "https://gbdk.org/"
  license :cannot_represent

  if Hardware::CPU.arm?
    url "https://github.com/gbdk-2020/gbdk-2020/releases/download/4.5.0/gbdk-macos-arm64.tar.gz"
    sha256 "289ee60e46c5a2785a21e35533f84a5131ed4a063b21b0dbdedc9a10af15bf78"
  else
    url "https://github.com/gbdk-2020/gbdk-2020/releases/download/4.5.0/gbdk-macos.tar.gz"
    sha256 "1aa549d12032d8f6509d11923bb28b1a453098f42597feb378e9a42541f8fd89"
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on :macos

  def install
    libexec.install Dir["*"]

    # lcc falls back to /opt/gbdk unless GBDKDIR points at its bundled SDCC,
    # so it cannot simply be symlinked onto PATH.
    (bin/"lcc").write_env_script libexec/"bin/lcc", GBDKDIR: "#{libexec}/"

    # Only link GBDK's own tools; its SDCC binaries would clash with the sdcc formula.
    %w[bankpack gbcompress ihxcheck makecom makenes png2asset png2hicolorgb romusage].each do |tool|
      bin.install_symlink libexec/"bin"/tool
    end
  end

  def caveats
    <<~EOS
      Makefiles from the GBDK examples locate the toolchain with GBDK_HOME:
        export GBDK_HOME="#{opt_libexec}"
    EOS
  end

  test do
    (testpath/"hello.c").write <<~C
      #include <gb/gb.h>
      #include <stdio.h>

      void main(void) {
        printf("Hello");
      }
    C
    system bin/"lcc", "-o", "hello.gb", "hello.c"
    assert_equal 32768, (testpath/"hello.gb").size
    assert_match "ROM_0", shell_output("#{bin}/romusage hello.gb")
  end
end
