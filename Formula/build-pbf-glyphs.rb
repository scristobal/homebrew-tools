class BuildPbfGlyphs < Formula
  desc "Generate protobuf-encoded SDF font glyphs from source fonts"
  homepage "https://github.com/stadiamaps/sdf_font_tools"
  url "https://static.crates.io/crates/build_pbf_glyphs/build_pbf_glyphs-1.5.1.crate"
  sha256 "5e5003ebe630b7b0bc6ddb936373afbd924beb943fe21df0c069310d89b1443c"
  license "BSD-3-Clause"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir testpath/"fonts"
    mkdir testpath/"out"
    cp "/System/Library/Fonts/Supplemental/Arial.ttf", testpath/"fonts"
    system bin/"build_pbf_glyphs", testpath/"fonts", testpath/"out"
    assert_path_exists testpath/"out/Arial/0-255.pbf"
  end
end
