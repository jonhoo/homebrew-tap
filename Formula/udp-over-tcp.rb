class UdpOverTcp < Formula
  desc "Command-line tool for tunneling UDP datagrams over TCP."
  homepage "https://github.com/jonhoo/udp-over-tcp"
  version "0.1.10"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jonhoo/udp-over-tcp/releases/download/v0.1.10/udp-over-tcp-aarch64-apple-darwin.tar.xz"
    sha256 "60f20fd16ccfdc90320fc9a52a3cab2dc78e6e22545c5d35f8477f014f4d9142"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jonhoo/udp-over-tcp/releases/download/v0.1.10/udp-over-tcp-x86_64-unknown-linux-musl.tar.xz"
    sha256 "82de96000c04853b9252a05c8089852b8008f3fe26e19e411a606858c6306636"
  end
  license any_of: ["MIT", "Apache-2.0"]

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
    bin.install "udp-over-tcp" if OS.mac? && Hardware::CPU.arm?
    bin.install "udp-over-tcp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
