class CargoNdk < Formula
  desc "Build Rust libraries for Android with cargo and the NDK"
  homepage "https://github.com/bbqsrc/cargo-ndk"
  url "https://static.crates.io/crates/cargo-ndk/cargo-ndk-4.1.2.crate"
  sha256 "903cc87cda6ab7a2ff82a74065e1c2ae5baa869546b32eb4aacabcc6ed5a670f"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # cargo-ndk refuses to run unless CARGO is set, as it is when cargo launches a subcommand.
    assert_match version.to_s, shell_output("CARGO=cargo #{bin}/cargo-ndk ndk --version")
  end
end
