require "language/node"

class TypescriptLanguageServer < Formula
  desc "TypeScript & JavaScript Language Server"
  homepage "https://github.com/typescript-language-server/typescript-language-server"
  url "https://registry.npmjs.org/typescript-language-server/-/typescript-language-server-5.0.1.tgz"
  sha256 "95b9272f733008ead40ba026d052c4dd272af2a53ef3b0c34dd9f57fb6962af1"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "typescript-language-server@5.0.1"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/typescript-language-server", "--help"
  end
end
