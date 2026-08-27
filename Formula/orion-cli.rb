class OrionCli < Formula
  desc "Command-line interface for the Orion declarative services runtime — manage workflows, channels, connectors, data, and traces from the terminal"
  homepage "https://docs.goplasmatic.io/"
  version "1.3.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v1.3.0/orion-cli-aarch64-apple-darwin.tar.xz"
    sha256 "d76b97f6f59a70601a4c9cc61beffbc8d0b365fb9f31baac4a70235c99468a25"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.3.0/orion-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "af83e65deb8bcccdfc66b6108d6a0fce185fbdeafb7238fe7c71ba8050e69b59"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.3.0/orion-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b72b1f4b2ff33e018f070b14e0c9cb513ca7416dec6dd503003a1a425c7c13ff"
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
