class OrionCli < Formula
  desc "CLI tool for the Orion services runtime"
  homepage "https://github.com/GoPlasmatic/Orion-cli"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.2.0/orion-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9ce57784a0e51ed2add486a00c6e9a194b904ba0913fcc431a5050ad6f054112"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.2.0/orion-cli-x86_64-apple-darwin.tar.xz"
      sha256 "3169716be8457c54390b872a8bef526bf22b65eb68ddb6513cbd152907d1da7c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.2.0/orion-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e66d5dce956c899ad05ee12ac3e99afa4413224657e1bde25968145667663e25"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.2.0/orion-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3588a39de3202de8a3cdcb7528e36131441f3927df8d5d93b5ce8ec46ab98f69"
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
