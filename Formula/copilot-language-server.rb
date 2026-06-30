require "language/node"

class CopilotLanguageServer < Formula
  desc "GitHub Copilot Language Server"
  homepage "https://github.com/github/copilot-language-server"
  url "https://registry.npmjs.org/@github/copilot-language-server/-/copilot-language-server-1.515.0.tgz"
  sha256 "fdd5f2b2854f5c50c60b7348a361dfec861f17300474aca9e26072f0574d65c4"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "@github/copilot-language-server@1.515.0"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/copilot-language-server", "--help"
  end
end
