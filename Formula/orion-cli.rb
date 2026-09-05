class OrionCli < Formula
  desc "Command-line client for the Orion declarative services runtime"
  homepage "https://docs.goplasmatic.io/"
  version "1.6.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v1.6.0/orion-cli-aarch64-apple-darwin.tar.xz"
    sha256 "242cce1414af8cfa1187d2f3753302e1845b2855f9fda0a6eada8f7cc179df59"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.6.0/orion-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "321f4635d37f990f0fec4446cf1341ca5a83004f5de933e742d5cf3caf5e9170"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.6.0/orion-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4ccd32913f77cb2e2c4143e5d5a91d907ffc8dbd33f50ad2d9aa07e1eedacba8"
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
      bin.install "orion-cli"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "orion-cli"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "orion-cli"
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
