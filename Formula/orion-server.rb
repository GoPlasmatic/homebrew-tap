class OrionServer < Formula
  desc "Declarative services runtime powered by dataflow-rs"
  homepage "https://github.com/GoPlasmatic/Orion"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v0.1.0/orion-server-aarch64-apple-darwin.tar.xz"
      sha256 "a62bb35c3b83ef93d81de82fa141ffda3156c2576cef4510a0ddf40e29ec2c7b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v0.1.0/orion-server-x86_64-apple-darwin.tar.xz"
      sha256 "65da430d1c7eb06fcf0922dccdb533610716a2457ab862c209829a7e860686b1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v0.1.0/orion-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c9758ca999aa7cd76ed6858b1035e3acd9d239a093a7fe9fd13d5c66abcd1bcc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v0.1.0/orion-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "322a82e19182b4f41b4ba5a88f96f5634a9faaa110e5fedb071ae1ce69f86241"
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
    bin.install "orion-server" if OS.mac? && Hardware::CPU.arm?
    bin.install "orion-server" if OS.mac? && Hardware::CPU.intel?
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
