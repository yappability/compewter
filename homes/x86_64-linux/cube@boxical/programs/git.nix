{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "boxical";
    userEmail = "160648427+boxical@users.noreply.github.com";
    extraConfig = {
      core.editor = "code --wait";
      init.defaultBranch = "main";
      commit.gpgsign = true;
      user.signingkey = "~/.ssh/id_ed25519.pub";
      gpg.format = "ssh";
      credential = {
        credentialStore = "plaintext";
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      };
    };
  };
}
