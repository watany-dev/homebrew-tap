class Ptuf < Formula
  desc "PreToolUseFilter: a generic guardrail layer for coding agents"
  homepage "https://github.com/watany-dev/ptuf"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.4.0/ptuf-aarch64-apple-darwin.tar.gz"
      sha256 "59b36b5ab6ce17beb00b297703237d40ea90f3afc5bb718c8c2f64b155948bf9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.4.0/ptuf-x86_64-apple-darwin.tar.gz"
      sha256 "d7aeee365c068690e723ffff72a948886e461ffe2a958bf743eecd1061dcb255"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.4.0/ptuf-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6b4ba3d089b3f377662f20fe53ed518508954280cdc25116ac8e63aab6eb9bf9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.4.0/ptuf-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1466426b425cc74dcd5eb5997221c84a5000d218d288e4dd4f18ca83b6523050"
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
