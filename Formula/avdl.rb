class Avdl < Formula
  desc "Avro IDL compiler that turns .avdl into .avpr and .avsc JSON files"
  homepage "https://github.com/jonhoo/avdl"
  version "0.1.4+1.12.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jonhoo/avdl/releases/download/v0.1.4+1.12.1/avdl-aarch64-apple-darwin.tar.xz"
    sha256 "53b99acb4047aaecf7d00ba78fe5ac363e2667908fe8363403f463e001436d08"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jonhoo/avdl/releases/download/v0.1.4+1.12.1/avdl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "28bc439a57b6a90f5e92d2f5b08dadfb5697585f631d4517d4ae8608d4c68531"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jonhoo/avdl/releases/download/v0.1.4+1.12.1/avdl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "209b98e600a5eef25f9e2242379058af8227f23f609c021a8822a20a0b53ba9b"
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
