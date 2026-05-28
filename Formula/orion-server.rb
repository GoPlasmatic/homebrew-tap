class OrionServer < Formula
  desc "Declarative services runtime powered by dataflow-rs"
  homepage "https://github.com/GoPlasmatic/Orion"
  version "0.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v0.2.0/orion-server-aarch64-apple-darwin.tar.xz"
    sha256 "8a4111deb8eb25c1e75c472396f94ee1e9e6f3ac1d36de5aebe7c4512f556791"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v0.2.0/orion-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "20e3e57809120462ccba6d2f6ebc66f27c0545563f13b82a25c85fc4aa9812c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v0.2.0/orion-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4ddef7db514f7feda0f4f761ba5b014f910b9b790c3c141c2c5f83b03b7fe67c"
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
