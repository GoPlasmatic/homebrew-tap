class OrionCli < Formula
  desc "Command-line interface for the Orion declarative services runtime — manage workflows, channels, connectors, data, and traces from the terminal"
  homepage "https://docs.goplasmatic.io/"
  version "1.2.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/GoPlasmatic/Orion/releases/download/v1.2.1/orion-cli-aarch64-apple-darwin.tar.xz"
    sha256 "de6066c8561ca193e8bfdcd22781ab1f90517dcec9b7626aa657fbad017416af"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.2.1/orion-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "42bcc36ee5e54c164de2efc9e4202307ffd32e958462ad22e353a8f20eef20c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GoPlasmatic/Orion/releases/download/v1.2.1/orion-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "084e562421197014914ebec84a61a8b5b4f3cbd19eaa41d45b07d2c86e70bb1b"
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
