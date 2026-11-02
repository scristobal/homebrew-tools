require "language/node"

class TypescriptLanguageServer < Formula
  desc "TypeScript & JavaScript Language Server"
  homepage "https://github.com/typescript-language-server/typescript-language-server"
  url "https://registry.npmjs.org/typescript-language-server/-/typescript-language-server-6.0.3.tgz"
  sha256 "96c1b2aa0cd72db1d653438870f3b2b4cd6b2b508ca4903ce7c798dda59bc151"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "typescript-language-server@6.0.3"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/typescript-language-server", "--help"
  end
end
