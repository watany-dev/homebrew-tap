class Ptuf < Formula
  desc "PreToolUseFilter: a generic guardrail layer for coding agents"
  homepage "https://github.com/watany-dev/ptuf"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.2.0/ptuf-aarch64-apple-darwin.tar.gz"
      sha256 "98a39f3c00f10bc647f1cf9e36c664be89f8b6f89b72a2164749e42d76487281"
    end
    if Hardware::CPU.intel?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.2.0/ptuf-x86_64-apple-darwin.tar.gz"
      sha256 "5e32206873fd693b2cb4db2ec505fe99bd1186f9e479c32a15b32db4f947ad3b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.2.0/ptuf-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b3bb36e6581bbe5503daf59d8831c0419160668fb6551d56ea7e4797f0b8f18f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.2.0/ptuf-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f560c6995d9128fbf26a528ad56266f43b0067c3f000ff3fb313951d90484eae"
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
