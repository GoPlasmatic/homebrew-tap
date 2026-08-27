class OrionServer < Formula
  desc "Turn business logic into live REST/Kafka services. Declare workflows as JSON and Orion runs them, with rate limiting, circuit breakers, versioning, and observability built in"
  homepage "https://goplasmatic.io/orion"
  version "1.3.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v1.3.1/orion-server-aarch64-apple-darwin.tar.xz"
    sha256 "1a4a4b7e8bbc9ce65ed6145afce159177df91b09174a982b379e8d5dc338d7ee"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.3.1/orion-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e6566c5f3dd8c18aea2c57be42d0fe122f3cc46b2e576c2298a827501062c14a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.3.1/orion-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "947846840537888f2cd9905ab458fe73631e21c2078f67c5dd29bee157f7026f"
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
