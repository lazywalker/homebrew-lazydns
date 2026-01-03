class Lazydns < Formula
  desc "A DNS server/forwarder implementation in Rust, inspired by mosdns"
  homepage "https://github.com/lazywalker/lazydns"
  version "0.2.60"
  license "GPL-3.0-or-later"

  on_arm do
    url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-aarch64-apple-darwin.tar.gz"
    sha256 "6517c7ff148487a6b2648264d1334f3e1f59dd747e5b68dddb2c34c64290cfb2"
  end

  on_intel do
    url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-x86_64-apple-darwin.tar.gz"
    sha256 "a30157e81455dfe8655e5aa8ea30b4f8a58633820d3cdc21df82e6143c3704dc"
  end

  on_linux do
    on_intel do
      url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "29a755b31ab65ad146c5436e22ba545a5a43b7650b75c8c129d4e872778a1ef3"
    end
    on_arm do
      url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c2ce71692540b25091ec3e1632f3c80390479701e6de28356276bb8344987276"
    end
  end

  def install
    bin.install "lazydns"
    pkgshare.install "config.yaml"
  end

  def post_install
    (etc/"lazydns").mkpath
    config_file = etc/"lazydns/config.yaml"
    unless config_file.exist?
      cp pkgshare/"config.yaml", config_file
    end
  end

  service do
    run [opt_bin/"lazydns", "-c", etc/"lazydns/config.yaml"]
    keep_alive true
    require_root true
  end

  def caveats
    <<~EOS
      A default configuration file has been installed to:
        #{etc}/lazydns/config.yaml

      You can edit this file to customize your settings.
      Then, start the service with:
        brew services start lazydns

    EOS
  end

  test do
    assert_match "lazydns #{version}", shell_output("#{bin}/lazydns --version")
  end
end
