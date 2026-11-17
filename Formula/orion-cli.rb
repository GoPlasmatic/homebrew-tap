class OrionCli < Formula
  desc "Command-line client for the Orion declarative services runtime"
  homepage "https://docs.goplasmatic.io/"
  version "2.0.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v2.0.0/orion-cli-aarch64-apple-darwin.tar.xz"
    sha256 "2163fcad104f5ed2981b3c5f150ac2420c608f78d3592a62c1733a51861dd41d"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v2.0.0/orion-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0112943e7731cf3b25e9225dd05521cd8574f43ce474d0c9ac0273ead02a4c5c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v2.0.0/orion-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e5917870899292b10e18d26172e8dc841a55bfe278111d64ebab3cdb05db902a"
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
