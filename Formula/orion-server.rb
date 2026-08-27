class OrionServer < Formula
  desc "Turn business logic into live REST/Kafka services. Declare workflows as JSON and Orion runs them, with rate limiting, circuit breakers, versioning, and observability built in"
  homepage "https://goplasmatic.io/orion"
  version "1.3.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v1.3.0/orion-server-aarch64-apple-darwin.tar.xz"
    sha256 "919a99b87ea096b07618121939acb6b884e877cc81764c786e457075a8f2a77e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.3.0/orion-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "770d16dbec097662dac50641e90f2dee064bcf12b2fbd76fa0d0a9d223718d4a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.3.0/orion-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b1cab1736316eb62e2f7988b758da8c047c89007847d640deca8bb16ebe9a007"
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
