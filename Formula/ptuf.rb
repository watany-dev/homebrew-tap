class Ptuf < Formula
  desc "PreToolUseFilter: a generic guardrail layer for coding agents"
  homepage "https://github.com/watany-dev/ptuf"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.3.0/ptuf-aarch64-apple-darwin.tar.gz"
      sha256 "18a92a6ad5ca4839edd207ffb66eb6aded8934d4fb28362ae465d60c51458844"
    end
    if Hardware::CPU.intel?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.3.0/ptuf-x86_64-apple-darwin.tar.gz"
      sha256 "f62481ad9ef7dd0e315934201ca359988e415fd97a3ae33e6c656b48803af90f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.3.0/ptuf-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "11613696720e016295683155ac572d91ce978e0a0919ca3a040369a0c6bb1e23"
    end
    if Hardware::CPU.intel?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.3.0/ptuf-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e7ce1b7a780ff1154a4b2a6c2b89bb5197c1b6dc95f8b9a33afb898fd81e29f0"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
