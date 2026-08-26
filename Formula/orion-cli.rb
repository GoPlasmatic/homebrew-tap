class OrionCli < Formula
  desc "Command-line interface for the Orion declarative services runtime — manage workflows, channels, connectors, data, and traces from the terminal"
  homepage "https://docs.goplasmatic.io/"
  version "1.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v1.2.0/orion-cli-aarch64-apple-darwin.tar.xz"
    sha256 "361848490d0dda690f2502e5129ccb9e8074d9bc5b1b668a9d5b0187e58d4c85"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.2.0/orion-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b7876eab5c7d1e9adb6e953835dd55da1067971a47c6d281c116b3e45aa0fa33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.2.0/orion-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b619c76c61a3c0cb9443be19e212a07f19a4b7aa222867c13acb673397700d5a"
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
