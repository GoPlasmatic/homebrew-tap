class OrionCli < Formula
  desc "Command-line interface for the Orion declarative services runtime — manage workflows, channels, connectors, data, and traces from the terminal"
  homepage "https://docs.goplasmatic.io/"
  version "1.4.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v1.4.0/orion-cli-aarch64-apple-darwin.tar.xz"
    sha256 "a90e9c981a2f59c196929a359786c7557426ac2e60b1486021f3bcd79e7b05c8"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.4.0/orion-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "066c7da33ff861e68cfb0d2695c604a21f31737d41212bdf0bbcd00f26a495f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.4.0/orion-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5c9f65a75d4d4f4d6220a1f66a6c0b0005f53013c2e94c009f1e9a6e6f7ac3b6"
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
