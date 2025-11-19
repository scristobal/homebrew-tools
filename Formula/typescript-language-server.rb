require "language/node"

class TypescriptLanguageServer < Formula
  desc "TypeScript & JavaScript Language Server"
  homepage "https://github.com/typescript-language-server/typescript-language-server"
  url "https://registry.npmjs.org/typescript-language-server/-/typescript-language-server-5.1.2.tgz"
  sha256 "952d8bdfeaa214f98f551805c2961d16de52bf8ee5e2870e6a649ebd28c2d8e1"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "typescript-language-server@5.1.2"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/typescript-language-server", "--help"
  end
end
