class Avdl < Formula
  desc "Avro IDL compiler that turns .avdl into .avpr and .avsc JSON files"
  homepage "https://github.com/jonhoo/avdl"
  version "0.1.3+1.12.1"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/jonhoo/avdl/releases/download/v0.1.3+1.12.1/avdl-aarch64-apple-darwin.tar.xz"
      sha256 "48fd60b99f87bf3ecd8e1ecb120eba7072f1ccd59c2efffe5485381e0d256a09"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jonhoo/avdl/releases/download/v0.1.3+1.12.1/avdl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "114a8c56d8ff93f5ab2082b6e2d7f3f2851705f9862cfcada56f3f9a2061de90"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jonhoo/avdl/releases/download/v0.1.3+1.12.1/avdl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bc753653fbb03d4f8f3eeacb251ac0dcceec5844a03eba85154ea41fcab2468e"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "avdl" if OS.mac? && Hardware::CPU.arm?
    bin.install "avdl" if OS.linux? && Hardware::CPU.arm?
    bin.install "avdl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
