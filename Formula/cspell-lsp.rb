require "language/node"

class CspellLsp < Formula
  desc "A simple source code spell checker"
  homepage "https://github.com/vlabo/cspell-lsp"
  url "https://registry.npmjs.org//cspell-lsp/-/cspell-lsp-1.1.5.tgz"
  sha256 "1338db0080360e2e2cd9af7d0444553f1929adddf31a554dd1ba78997d1588af"
  license "GPL-3.0"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "@vlabo/cspell-lsp@1.1.5"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/cspell-lsp", "--help"
  end
end
