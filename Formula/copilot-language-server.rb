require "language/node"

class CopilotLanguageServer < Formula
  desc "GitHub Copilot Language Server"
  homepage "https://github.com/github/copilot-language-server"
  url "https://registry.npmjs.org/@github/copilot-language-server/-/copilot-language-server-1.476.0.tgz"
  sha256 "685694f7d4791ecbec31c64c76144a465d9b8fd219e34340ee004ac5e5ee3aef"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "@github/copilot-language-server@1.476.0"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/copilot-language-server", "--help"
  end
end
