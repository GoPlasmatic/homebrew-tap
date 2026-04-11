class OrionServer < Formula
  desc "Declarative services runtime powered by dataflow-rs"
  homepage "https://github.com/GoPlasmatic/Orion"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v0.1.1/orion-server-aarch64-apple-darwin.tar.xz"
    sha256 "5818aea1e0c41ed40e17ca9a0b6f1b6265b6a929766fcce01b28756be64cb5d4"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v0.1.1/orion-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5965414b7249f5d0b81de9855f3b5a74b489be4f6452bbc6c6039fb93c5b1c64"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v0.1.1/orion-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e632faf74aa8c5adc8118c8835e11a1a611bfb813a08d88621dd87d96fe1690c"
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
    bin.install "orion-server" if OS.mac? && Hardware::CPU.arm?
    bin.install "orion-server" if OS.linux? && Hardware::CPU.arm?
    bin.install "orion-server" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
