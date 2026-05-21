require "language/node"

class TypescriptLanguageServer < Formula
  desc "TypeScript & JavaScript Language Server"
  homepage "https://github.com/typescript-language-server/typescript-language-server"
  url "https://registry.npmjs.org/typescript-language-server/-/typescript-language-server-5.3.0.tgz"
  sha256 "398cacc17fff2108652e7b4050e3182008d17063246b3fea7dcf5fae2ce1560e"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "typescript-language-server@5.3.0"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/typescript-language-server", "--help"
  end
end
