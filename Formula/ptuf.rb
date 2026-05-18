class Ptuf < Formula
  desc "PreToolUseFilter: a generic guardrail layer for coding agents"
  homepage "https://github.com/watany-dev/ptuf"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.1.1/ptuf-aarch64-apple-darwin.tar.gz"
      sha256 "6c3472e59a639e3cd95290c70796e42a59d9ca3db4e536f31e8da6516120bb85"
    end
    if Hardware::CPU.intel?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.1.1/ptuf-x86_64-apple-darwin.tar.gz"
      sha256 "6e42a76ce073a43bce41225f1653cb9ef39c80016276ea8fcc18613caf53851a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.1.1/ptuf-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a553fd752ecd339836f3d22bfdecb14c765c52b0cc77bba28edd1f8a46716c10"
    end
    if Hardware::CPU.intel?
      url "https://github.com/watany-dev/ptuf/releases/download/v0.1.1/ptuf-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1e600b4953598df15ec990a25fd9cbe9b67ccddfcc31cc07f633d56d1f4b2475"
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
