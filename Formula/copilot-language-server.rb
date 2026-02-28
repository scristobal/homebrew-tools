require "language/node"

class CopilotLanguageServer < Formula
  desc "GitHub Copilot Language Server"
  homepage "https://github.com/github/copilot-language-server"
  url "https://registry.npmjs.org/@github/copilot-language-server/-/copilot-language-server-1.436.0.tgz"
  sha256 "93fa59d2fdeddd61a85b2b3679a760492f07a616b01210cd134176988233be19"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "@github/copilot-language-server@1.436.0"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/copilot-language-server", "--help"
  end
end
