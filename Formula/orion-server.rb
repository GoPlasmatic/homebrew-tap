class OrionServer < Formula
  desc "Turn business logic into live REST services, declared as JSON"
  homepage "https://goplasmatic.io/orion"
  version "2.0.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v2.0.0/orion-server-aarch64-apple-darwin.tar.xz"
    sha256 "73afeabae715e69004f515b9d16ec3120c36b94f318cce67a46eabe31ea2cba3"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v2.0.0/orion-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7d2f0622270442e22ca052e00b50fa338b59e0d9d8c460fc676cb25d07d11753"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v2.0.0/orion-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "064f6ca1424901ee04c0f2c13075b1da79169c33beec859daab6def38363e6f2"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "orion-server"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "orion-server"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "orion-server"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
