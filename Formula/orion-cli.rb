class OrionCli < Formula
  desc "Command-line client for the Orion declarative services runtime"
  homepage "https://docs.goplasmatic.io/"
  version "1.11.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v1.11.0/orion-cli-aarch64-apple-darwin.tar.xz"
    sha256 "68441f5ade123c61d0c1c46c3e45e78e81b8ee472af0ebe2196dc15b3a254844"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.11.0/orion-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "079e3c22981da757f4f9c07a639852ab0625efd2bb88255bbcb5e1bdd1a8a05c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.11.0/orion-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d4bd61dc45d3d7cf4e79fd043d84b2ecd79d28108631e3d80185aed27a6f60b9"
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
      bin.install "orion-cli"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "orion-cli"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "orion-cli"
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
