require "language/node"

class CopilotLanguageServer < Formula
  desc "GitHub Copilot Language Server"
  homepage "https://github.com/github/copilot-language-server"
  url "https://registry.npmjs.org/@github/copilot-language-server/-/copilot-language-server-1.467.0.tgz"
  sha256 "a2dedf42f477e16c3d9bf89dec27dead3067ea31d19ac2bb7e5fc0e200931896"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "@github/copilot-language-server@1.467.0"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/copilot-language-server", "--help"
  end
end
