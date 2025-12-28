class Lazydns < Formula
  desc "A DNS server/forwarder implementation in Rust, inspired by mosdns"
  homepage "https://github.com/lazywalker/lazydns"
  version "0.2.50"
  license "GPL-3.0-or-later"

  on_arm do
    url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-aarch64-apple-darwin.tar.gz"
    sha256 "8de9016528a4beaebbce018f90562bba9832ca7a2d5464624dbe5483048e4d07"
  end

  on_intel do
    url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-x86_64-apple-darwin.tar.gz"
    sha256 "3ee982c2b65b04321541cfed7aafd3e77eb2c9b6e28107a9dee554cde9266241"
  end

  on_linux do
    on_intel do
      url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "867071535910be989a81ea1f2c00b5f258c58491a8f4b1e087b41bf94f6de612"
    end
    on_arm do
      url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2b0e339c322576260613ea5ba389b7966f21ee1ccb948a013b0713f4e72b261d"
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
