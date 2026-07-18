class OrionServer < Formula
  desc "Declarative services runtime — deploy governed REST/Kafka services as JSON workflows, with rate limiting, circuit breakers, versioning, and observability built in"
  homepage "https://goplasmatic.io/orion"
  version "0.3.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v0.3.0/orion-server-aarch64-apple-darwin.tar.xz"
    sha256 "a39c2307ab39f9b42edb00757e1ac1aaa57ff5b3679f607099d90bf2026dc70c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v0.3.0/orion-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2f35bf163e4913fe9f9747355303eee03694686e01f9c8502890a38f96c2e249"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v0.3.0/orion-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "327dba25ac952f4a1ca5413e32ed295b460ad777e258e8d853942152be722583"
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
