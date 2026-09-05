class OrionServer < Formula
  desc "Turn business logic into live REST/Kafka services, declared as JSON"
  homepage "https://goplasmatic.io/orion"
  version "1.6.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v1.6.0/orion-server-aarch64-apple-darwin.tar.xz"
    sha256 "1cdedf18def88895bc042739f02f2438bd52b60d4a803785066b9d68b1a77285"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.6.0/orion-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d325e9c55c0072b77299ac4cb4959a58d43f8f13c4753e23123e12d02241b2e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.6.0/orion-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "222c58d185b8bccda8e8b2689ef85dcff45f749e65e254b93b64164c3b83a68a"
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
