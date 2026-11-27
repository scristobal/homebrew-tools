class ShaderLanguageServer < Formula
  desc "Language server for HLSL, GLSL and WGSL shaders"
  homepage "https://github.com/antaalt/shader-sense"
  url "https://static.crates.io/crates/shader_language_server/shader_language_server-2.0.0.crate"
  sha256 "90f0c76bdab7cb041e44356f61fd0415b99aa9cd9228e838e2ae3d6346005b3c"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shader-language-server --version")
  end
end
