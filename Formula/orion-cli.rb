class OrionCli < Formula
  desc "CLI tool for the Orion services runtime"
  homepage "https://github.com/GoPlasmatic/Orion-cli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.1.0/orion-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a73364de053895623aef539d8cd894d016213a994688e21682268d97566318fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.1.0/orion-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f7ba941bef723192d420131b23684ada38b46a15d1f55264fa0eb2c0f00f1a8e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.1.0/orion-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "56845d799d9a3f980d13fcdc4e6a023bbd973396860991fa8c8a4cc71b8a3916"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.1.0/orion-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0cbff8c2cc5b47162c571e206949552ec81d990226f64c633349c1ef09e89086"
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
