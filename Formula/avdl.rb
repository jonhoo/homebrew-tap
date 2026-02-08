class Avdl < Formula
  desc "Avro IDL compiler that turns .avdl into .avpr and .avsc JSON files"
  homepage "https://github.com/jonhoo/avdl"
  version "0.1.2+1.12.1"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/jonhoo/avdl/releases/download/v0.1.2+1.12.1/avdl-aarch64-apple-darwin.tar.xz"
      sha256 "7c3d9435c1a9a4fca17323fb1cb198b2f3b4d3f9e4df7119436c75642c3d2890"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jonhoo/avdl/releases/download/v0.1.2+1.12.1/avdl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a066e19defc4cd3adb461bbe1d29d13ca78fd2fd6cf74c567224d641f22e71c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jonhoo/avdl/releases/download/v0.1.2+1.12.1/avdl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "13804fd84e9f3de82afdee1764099eb1eec12c4863b0e4a2b854268dd7db149e"
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
