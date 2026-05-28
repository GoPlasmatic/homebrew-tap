class OrionCli < Formula
  desc "CLI tool for the Orion services runtime"
  homepage "https://github.com/GoPlasmatic/Orion-cli"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.2.0/orion-cli-aarch64-apple-darwin.tar.xz"
      sha256 "75a62dfb8ea239dc8ccdcaa3cdcb9840323a5aa6ac831b1f5ef6aa9f2447170f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.2.0/orion-cli-x86_64-apple-darwin.tar.xz"
      sha256 "063278bd6987ad063c4e70d45fe14d34f411b3b57fade155d30258ac76c2add8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.2.0/orion-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8704f23c3c0782ee39e04cda997c1085fcb643bb196b092872b370e2b7e9ff0e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.2.0/orion-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6fe4b1e179bd05b7245ce4e3a9b36ee680afe4a337ef3597543ed13563f50045"
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
    bin.install "orion-cli" if OS.mac? && Hardware::CPU.arm?
    bin.install "orion-cli" if OS.mac? && Hardware::CPU.intel?
    bin.install "orion-cli" if OS.linux? && Hardware::CPU.arm?
    bin.install "orion-cli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
