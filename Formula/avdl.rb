class Avdl < Formula
  desc "Port of avro-tools' Avro IDL compiler that compiles .avdl files to Avro Protocol JSON (.avpr) or Schema JSON (.avsc)"
  homepage "https://github.com/jonhoo/avdl"
  version "0.1.1+1.12.1"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/jonhoo/avdl/releases/download/v0.1.1+1.12.1/avdl-aarch64-apple-darwin.tar.xz"
      sha256 "711276daadbd761e0ddebc55ce5d75e388e088abc0837780b5933f92a4e05b4c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jonhoo/avdl/releases/download/v0.1.1+1.12.1/avdl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dafe177f026b88016d91246671cd8ff3c7e3da5bc8fb101473bcc25eb1703854"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jonhoo/avdl/releases/download/v0.1.1+1.12.1/avdl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "03e5c1198141d5bb83a1a7f1cba97b58a0f4d0121f737e9687ec1dc6a41ab62f"
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
