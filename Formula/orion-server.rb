class OrionServer < Formula
  desc "Declarative services runtime powered by dataflow-rs"
  homepage "https://github.com/GoPlasmatic/Orion"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v0.1.0/orion-server-aarch64-apple-darwin.tar.xz"
      sha256 "e2e3b0315c50f0378281d0b7296c087e5f5c855396ff04740f4feed0a72803af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v0.1.0/orion-server-x86_64-apple-darwin.tar.xz"
      sha256 "9b640fabe85cedc8941ee71c9213c5cc6fa18778e6e5f3129a6fd3d6905f3a9f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v0.1.0/orion-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "86297581769013f9a2fee8f21e2214ece91fe0619510037117e59ce9e01d618f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v0.1.0/orion-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ada1d35db81a32b143fef85bc3d7aa8f10bd7c0b04f65691399eb1dc427fd10e"
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
    bin.install "orion-server" if OS.mac? && Hardware::CPU.arm?
    bin.install "orion-server" if OS.mac? && Hardware::CPU.intel?
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
