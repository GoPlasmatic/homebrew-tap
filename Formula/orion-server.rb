class OrionServer < Formula
  desc "Turn business logic into live REST/Kafka services. Declare workflows as JSON and Orion runs them, with rate limiting, circuit breakers, versioning, and observability built in"
  homepage "https://goplasmatic.io/orion"
  version "1.2.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v1.2.1/orion-server-aarch64-apple-darwin.tar.xz"
    sha256 "e49a5864345b32dc5d3f5944a126f894c9620b55084b40f455818c00cebe379d"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.2.1/orion-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c3a36b1cb1d9efdfbcc30df99150b513ad63329886261f69ca7a4c9c82c93e3f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.2.1/orion-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9699527120a4f9b735787c2eb3e2fb90825ee789eb045b96097bdd58bcba23bf"
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
