class Ptuf < Formula
  desc "PreToolUseFilter: a generic guardrail layer for coding agents"
  homepage "https://github.com/watany-dev/ptuf"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.5.0/ptuf-aarch64-apple-darwin.tar.gz"
      sha256 "35e5d170e8e2407f80e599aba593d3af1dbebadfb935ee23a211cc52b4f86217"
    end
    if Hardware::CPU.intel?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.5.0/ptuf-x86_64-apple-darwin.tar.gz"
      sha256 "48cb2a7ec671409b1356b4d0ef4a15fcb396e2dad92b658a8425a1f8025e1dfb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.5.0/ptuf-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "24d1c337e7cad89bc07c255972999d1692e86054d264f4422ffc93ca09f4f7f3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.5.0/ptuf-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6ef72535ec2a37b4f6796a6a3c0a0eccb102aade174668b5d06fc02c0b25bf09"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    bin.install "ptuf" if OS.mac? && Hardware::CPU.arm?
    bin.install "ptuf" if OS.mac? && Hardware::CPU.intel?
    bin.install "ptuf" if OS.linux? && Hardware::CPU.arm?
    bin.install "ptuf" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
