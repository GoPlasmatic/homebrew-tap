class OrionCli < Formula
  desc "CLI and MCP server for the Orion declarative services runtime — manage workflows, channels, connectors, data, and traces from the terminal or an AI client"
  homepage "https://github.com/GoPlasmatic/Orion-cli"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.2.1/orion-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4b7ea5f145044ecea1ffe6e378e2f73dd19ec695fa5b82fd8a2b552c57a89369"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.2.1/orion-cli-x86_64-apple-darwin.tar.xz"
      sha256 "984ec833b82f1d46dfd0ebc6004baa33e64501b2dc7bc991004f36e215ef250e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.2.1/orion-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8d7e0980c184a7519cc2b1b01945004a7d90b97c62aef696507ad662e20dcb43"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.2.1/orion-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "399cc2cea906bb4fec7fceb4fd70d422a03242b6af7a95bafa6e766cb624c1a6"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "orion-cli" if OS.mac? && Hardware::CPU.arm?
    bin.install "orion-cli" if OS.mac? && Hardware::CPU.intel?
    bin.install "orion-cli" if OS.linux? && Hardware::CPU.arm?
    bin.install "orion-cli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
