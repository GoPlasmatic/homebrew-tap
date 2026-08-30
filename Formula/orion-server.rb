class OrionServer < Formula
  desc "Turn business logic into live REST/Kafka services. Declare workflows as JSON and Orion runs them, with rate limiting, circuit breakers, versioning, and observability built in"
  homepage "https://goplasmatic.io/orion"
  version "1.4.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v1.4.0/orion-server-aarch64-apple-darwin.tar.xz"
    sha256 "dada8f24976d69e71c997431c8cfddc5ec5d57c1451576260f8a42fb65fa6144"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.4.0/orion-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c2ef3fa9c9550112ddcf8d69e9ec93428aed1aa7171d0d982d602a14f5fbc1d1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.4.0/orion-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1c63a1a5f466c1607b9df29144f996b8082353950b62abac789ccf9c0e59f703"
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
