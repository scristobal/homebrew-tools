class EditFork < Formula
  desc "Simple text editor with clickable interface, built from scristobal/edit"
  homepage "https://github.com/scristobal/edit"
  license "MIT"
  head "https://github.com/scristobal/edit.git", branch: "main"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
  end

  conflicts_with "msedit", because: "both install an `edit` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/edit")
  end

  test do
    assert_match "edit version", shell_output("#{bin}/edit --version")
  end
end
