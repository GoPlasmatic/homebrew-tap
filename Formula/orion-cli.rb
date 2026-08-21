class OrionCli < Formula
  desc "CLI and MCP server for the Orion declarative services runtime — manage workflows, channels, connectors, data, and traces from the terminal or an AI client"
  homepage "https://docs.goplasmatic.io/"
  version "1.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v1.1.0/orion-cli-aarch64-apple-darwin.tar.xz"
    sha256 "2da7f12c4045cf66e3053f8201fb3a82205a03eb0b96bd0c8423ca8b8df0ddb5"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.1.0/orion-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0da0dbac9410fecba4fa618674810c599c1c9c8ffd6efac964e5629e57d4f7c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.1.0/orion-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "84f5d1d06eb8fe494acbc4cbe4dc0f32031999596855f1b92edd288ba03bc2c9"
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
