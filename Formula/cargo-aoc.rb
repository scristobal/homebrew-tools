class CargoAoc < Formula
  desc "Cargo Advent of Code helper"
  homepage "https://github.com/gobanos/cargo-aoc"
  url "https://static.crates.io/crates/cargo-aoc/cargo-aoc-0.3.8.crate"
  sha256 "0f564309b8f9d03c989910b845ac0b9cc1ea2228d0f504acfe02679f6d62712b"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cargo-aoc aoc --version")
  end
end
