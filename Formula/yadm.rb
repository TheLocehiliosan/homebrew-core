class Yadm < Formula
  desc "Yet Another Dotfiles Manager"
  homepage "https://yadm.io/"
  url "https://github.com/TheLocehiliosan/yadm/archive/2.0.0.tar.gz"
  sha256 "6359debdd9a6154709d084f478c000e572b3d8d50c2abe6525534899a5c2eb16"

  bottle :unneeded

  def install
    post_install_message = any_version_installed?
    bin.install "yadm"
    man1.install "yadm.1"
    bash_completion.install "completion/yadm.bash_completion"
    zsh_completion.install  "completion/yadm.zsh_completion" => "_yadm"
    doc.install "CHANGES"
    doc.install "CONTRIBUTORS"
    doc.install "LICENSE"
    doc.install "contrib"
    if post_install_message
      opoo <<~EOS


        Beginning with version 2.0.0, yadm introduced a few major changes which may
        require you to adjust your configurations.

        If you want to retain yadm's old behavior until you transition your
        configurations, you can set an environment variable "YADM_COMPATIBILITY=1".
        Doing so will automatically use the old yadm directory, and process alternates
        the same as version 1. This compatibility mode is deprecated, and will be
        removed in future versions. This mode exists solely for transitioning to the
        new paths and naming of alternates.

        See https://yadm.io/docs/upgrade_from_1 for more details.

      EOS
    end
  end

  test do
    system bin/"yadm", "init"
    assert_predicate testpath/".config/yadm/repo.git/config", :exist?, "Failed to init repository."
    assert_match testpath.to_s, shell_output("#{bin}/yadm gitconfig core.worktree")

    # disable auto-alt
    system bin/"yadm", "config", "yadm.auto-alt", "false"
    assert_match "false", shell_output("#{bin}/yadm config yadm.auto-alt")

    (testpath/"testfile").write "test"
    system bin/"yadm", "add", "#{testpath}/testfile"

    system bin/"yadm", "gitconfig", "user.email", "test@test.org"
    system bin/"yadm", "gitconfig", "user.name", "Test User"

    system bin/"yadm", "commit", "-m", "test commit"
    assert_match "test commit", shell_output("#{bin}/yadm log --pretty=oneline 2>&1")
  end
end
