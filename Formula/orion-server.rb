class OrionServer < Formula
  desc "Turn business logic into live REST/Kafka services. Declare workflows as JSON and Orion runs them, with rate limiting, circuit breakers, versioning, and observability built in"
  homepage "https://goplasmatic.io/orion"
  version "1.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v1.2.0/orion-server-aarch64-apple-darwin.tar.xz"
    sha256 "513c6b6622d92259f561078f93b21e6eadd70416c1012339ad8b387d2d9248d8"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.2.0/orion-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "77242fb0408d2cb3c9a8c8275ca726831cd2824599c5e27ad99e31401f178867"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.2.0/orion-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "beae787cc5eac93adc9879852f4f3a6c179dcd1b08852e9f2c1fed1b20e89210"
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
