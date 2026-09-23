class OrionServer < Formula
  desc "Turn business logic into live REST/Kafka services, declared as JSON"
  homepage "https://goplasmatic.io/orion"
  version "1.9.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v1.9.1/orion-server-aarch64-apple-darwin.tar.xz"
    sha256 "0af1b0c1fd126db75ee65ec4e7e18056789d6a7d6ca0f352a4fdd930a955e4aa"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.9.1/orion-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "da1e6567c7ad2d64a2ce65ae35c82cf73c7883b7e84e46cb6d100c92b458b222"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.9.1/orion-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ef023f0cf883325dc55ae7b225ffcf0426b60055b0f92e627aa01c2f3fc73ba3"
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
      bin.install "orion-server"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "orion-server"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "orion-server"
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
