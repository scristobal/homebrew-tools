class CargoTreeTui < Formula
  desc "Interactive tree view of a Cargo dependency graph"
  homepage "https://github.com/orhun/cargo-tree-tui"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/orhun/cargo-tree-tui.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "cargo-tree-tui", shell_output("#{bin}/cargo-tree-tui tree-tui --version")
  end
end
