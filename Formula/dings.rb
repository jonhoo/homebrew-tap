class Dings < Formula
  desc "quick command-line data visualization"
  homepage "https://github.com/jonhoo/dings/"
  version "0.1.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jonhoo/dings/releases/download/v0.1.2/dings-aarch64-apple-darwin.tar.xz"
    sha256 "2c329a93510c3762711876b346dbb02ad83498168b2d10f74528fb062405052e"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jonhoo/dings/releases/download/v0.1.2/dings-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "58d24207f74da47a2f73e4a9af4fba2971e1aae163970ca8ee6fd1214571f024"
  end
  license "ISC"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "dings" if OS.mac? && Hardware::CPU.arm?
    bin.install "dings" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
