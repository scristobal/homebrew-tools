class CargoSwift < Formula
  desc "Build Swift packages from Rust code for iOS and macOS apps"
  homepage "https://github.com/antoniusnaumann/cargo-swift"
  url "https://static.crates.io/crates/cargo-swift/cargo-swift-0.11.1.crate"
  sha256 "f3422f2871084146c967dfa7d77132ebc500dd749ad23a3608eac940f0c6b2ea"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cargo-swift swift --version")
  end
end
