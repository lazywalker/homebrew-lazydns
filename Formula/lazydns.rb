class Lazydns < Formula
  desc "A DNS server/forwarder implementation in Rust, inspired by mosdns"
  homepage "https://github.com/lazywalker/lazydns"
  version "0.2.43"
  license "GPL-3.0-or-later"

  on_arm do
    url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-aarch64-apple-darwin.tar.gz"
    sha256 "200860164d8dc20f11a7486cc3da816a3ee64a9f75e0d2d19f4cb478dc87d9d3"
  end

  on_intel do
    url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-x86_64-apple-darwin.tar.gz"
    sha256 "ff83d17bb6af992b2493467f2ce2ae1fb2a1cb5255c221a6d41107aa90a02137"
  end

  on_linux do
    on_arm do
      url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "placeholder_sha256_for_arm_linux"  
    end
    on_intel do
      url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fc03c241710306a640477b449da3cbd25f7a3df276b5e72f0c047df5a1726609"
    end
  end

  def install
    bin.install "lazydns"
    pkgshare.install "config.yaml"
  end

  def post_install
    (etc/"lazydns").mkpath
    config_file = etc/"lazydns/config.yaml"
    config_file.write(pkgshare/"config.yaml").read unless config_file.exist?
  end

  service do
    run [opt_bin/"lazydns", "--config", etc/"lazydns/config.yaml"]
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
