require "language/node"

class TypescriptLanguageServer < Formula
  desc "TypeScript & JavaScript Language Server"
  homepage "https://github.com/typescript-language-server/typescript-language-server"
  url "https://registry.npmjs.org/typescript-language-server/-/typescript-language-server-6.0.2.tgz"
  sha256 "d225b223a8a4764ecbd94bdba85d2ef185eaa7b9842a1a31c38c2bbe7f2fe9b9"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "typescript-language-server@6.0.2"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/typescript-language-server", "--help"
  end
end
