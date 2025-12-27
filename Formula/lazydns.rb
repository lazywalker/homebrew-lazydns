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
  end

  service do
    run [opt_bin/"lazydns", "--config", etc/"lazydns/config.yaml"]
    keep_alive true
    require_root true
  end

  def caveats
    <<~EOS
      To set up lazydns, you may want to edit the configuration file at:
        #{etc}/lazydns/config.yaml
        Then, you can start the service with:
            brew services start lazydns

    EOS
  end

  test do
    assert_match "lazydns #{version}", shell_output("#{bin}/lazydns --version")
  end
end
