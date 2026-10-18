class ShaderLanguageServer < Formula
  desc "Language server for HLSL, GLSL and WGSL shaders"
  homepage "https://github.com/antaalt/shader-sense"
  url "https://static.crates.io/crates/shader_language_server/shader_language_server-1.6.2.crate"
  sha256 "3eb11ba123a0c6a1f43ebac46f3a7423d9d12ff56183711b5bea692fbb203ae4"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shader-language-server --version")
  end
end
