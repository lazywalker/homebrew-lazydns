class Lazydns < Formula
  desc "A DNS server/forwarder implementation in Rust, inspired by mosdns"
  homepage "https://github.com/lazywalker/lazydns"
  version "0.2.50"
  license "GPL-3.0-or-later"

  on_arm do
    url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-aarch64-apple-darwin.tar.gz"
    sha256 "e4d40fdd6ea356e0f2afe098744c4cb9d1f149fd1ec922eef5901b1fc96caec6"
  end

  on_intel do
    url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-x86_64-apple-darwin.tar.gz"
    sha256 "ac65de737c1e05536d37f574ee57d99467406698f5b11ff5d5ff3f16c23b3fc6"
  end

  on_linux do
    on_intel do
      url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6c303d613a843afeb00f6dc38dbde2f446a4352b0f09c873ec41bfdaaef70898"
    end
    on_arm do
      url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "94d532613ca95e027afad11f0b76f5f7d5687ea1bad36b022d0b68b532b88d73"
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
