class Controlpctl < Formula
  desc "Learny Technologies Control Plane command-line client"
  homepage "https://github.com/learny-technologies/control-plane-workspace"
  url "https://github.com/learny-technologies/homebrew-tap/archive/refs/tags/controlpctl-bootstrap-0.2.0.tar.gz"
  version "0.2.0"
  sha256 "d520048952b9391f4c60968d8069f39ae7fa64b17ed3773cfd8cddced2dc7829"
  license "Proprietary"

  CONTROL_PLANE_REPOSITORY = "learny-technologies/control-plane-workspace".freeze
  RELEASE_SHA256 = "dad43d6ede0832739bdb26948846897183afda3ad8816a650030910c9435e47d".freeze

  depends_on "gh"
  depends_on "python@3.12"

  def install
    token = ENV.fetch("HOMEBREW_GITHUB_API_TOKEN", "")
    odie "Pass a GitHub token with repo access through HOMEBREW_GITHUB_API_TOKEN" if token.empty?
    ENV["GH_TOKEN"] = token
    authorized = system "gh", "auth", "status"
    odie "GitHub token cannot read the private Control Plane release" unless authorized

    wheel_name = "controlp-#{version}-py3-none-any.whl"
    release_dir = buildpath / "release"
    release_dir.mkpath
    system "gh", "release", "download", "v#{version}",
           "--repo", CONTROL_PLANE_REPOSITORY,
           "--pattern", wheel_name,
           "--dir", release_dir,
           "--clobber"

    wheel = release_dir / wheel_name
    actual_digest = Digest::SHA256.file(wheel).hexdigest
    odie "Control Plane release checksum mismatch" if actual_digest != RELEASE_SHA256

    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install wheel
    bin.install_symlink libexec / "bin" / "controlpctl"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath / "config"
    assert_match "api.platform.learny.technology", shell_output("#{bin}/controlpctl profile show")
  end
end
