class Lazydns < Formula
  desc "A DNS server/forwarder implementation in Rust, inspired by mosdns"
  homepage "https://github.com/lazywalker/lazydns"
  version "0.2.52"
  license "GPL-3.0-or-later"

  on_arm do
    url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-aarch64-apple-darwin.tar.gz"
    sha256 "e487b20f1eda80229f0f3b2fb47d47e02c62f18874f2379c1de0b7081685aa92"
  end

  on_intel do
    url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-x86_64-apple-darwin.tar.gz"
    sha256 "a5af4764acd57ca4decad90bc1c4b2cc1e03fabd72694f724022a885125f79d7"
  end

  on_linux do
    on_intel do
      url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "38c5427d19ab64d0e7f19d8768b7a1939e72f9144a96f1c9dc74cf1d9a69c680"
    end
    on_arm do
      url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e6627e5d55012338c9ca05fe1df69e977cfaba09d29a80d71d8eb18e3961003f"
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
