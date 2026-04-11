class OrionCli < Formula
  desc "CLI tool for the Orion services runtime"
  homepage "https://github.com/GoPlasmatic/Orion-cli"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.1.1/orion-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0793fe9abefeb9a83d8a1def5b60dd5e2163fcd58ff76b080d99a1919cb33af7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.1.1/orion-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b4bc6db36e8c28c0ca7183dd3b4b1860e58beac5bced78179f7022fba8c8caa3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.1.1/orion-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6b9a21dc2133d6f580f0a08694908a6f40754c7c437c6b1331e9f20182e89235"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion-cli/releases/download/v0.1.1/orion-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "17eb003f2044eeb9f861747fdf1f0a4535b0bba16b0bf93bd714ad6dccf0176d"
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
