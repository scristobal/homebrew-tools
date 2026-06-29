require "language/node"

class CopilotLanguageServer < Formula
  desc "GitHub Copilot Language Server"
  homepage "https://github.com/github/copilot-language-server"
  url "https://registry.npmjs.org/@github/copilot-language-server/-/copilot-language-server-1.514.0.tgz"
  sha256 "f2c2003162dc91a01efb30276d05be88116bf1fc83446f06745f87f69606099e"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "@github/copilot-language-server@1.514.0"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/copilot-language-server", "--help"
  end
end
