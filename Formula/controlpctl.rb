class Controlpctl < Formula
  desc "Learny Technologies Control Plane command-line client"
  homepage "https://github.com/learny-technologies/control-plane-workspace"
  url "https://github.com/learny-technologies/homebrew-tap/archive/refs/tags/controlpctl-bootstrap-0.2.0.tar.gz"
  sha256 "d520048952b9391f4c60968d8069f39ae7fa64b17ed3773cfd8cddced2dc7829"
  version "0.2.0"
  license "Proprietary"

  CONTROL_PLANE_REPOSITORY = "learny-technologies/control-plane-workspace"
  RELEASE_SHA256 = "dad43d6ede0832739bdb26948846897183afda3ad8816a650030910c9435e47d"

  depends_on "gh"
  depends_on "python@3.12"

  def install
    unless system "gh", "auth", "status"
      odie "Sign in first with: gh auth login"
    end

    wheel_name = "controlp-#{version}-py3-none-any.whl"
    release_dir = buildpath / "release"
    release_dir.mkpath
    system "gh", "release", "download", "v#{version}",
           "--repo", CONTROL_PLANE_REPOSITORY,
           "--pattern", wheel_name,
           "--dir", release_dir,
           "--clobber"

    wheel = release_dir / wheel_name
    odie "Control Plane release checksum mismatch" unless Digest::SHA256.file(wheel).hexdigest == RELEASE_SHA256

    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install wheel
    bin.install_symlink libexec / "bin" / "controlpctl"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath / "config"
    assert_match "api.platform.learny.technology", shell_output("#{bin}/controlpctl profile show")
  end
end
