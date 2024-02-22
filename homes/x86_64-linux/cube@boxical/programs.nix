{ inputs, pkgs, system, lib, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = system;
    config.allowUnfree = true;
  };
  charliepkgs = inputs.charliepkgs;
in {
  programs = {
    firefox.enable = true;
    vscode.enable = true;
    obs-studio.enable = true;
    # bun = {
    #   enable = true;
    #   package = pkgs.me.bun;
    # };
    vesktop = {
      enable = true;
      package = lib.me.patchOutput unstable.vesktop ''
        rm -r $out/share/icons
        mkdir -p $out/share/icons/hicolor/scalable/apps/
        cp ${
          ./icons/vesktop.svg
        } $out/share/icons/hicolor/scalable/apps/vesktop.svg
      '';
    };
    nix-index-database.comma.enable = true;
    nushell = {
      enable = true;
      shellAliases = {
        switch = "sudo nixos-rebuild switch --fast --print-build-logs";
        nv = "nix develop --command code";
        gc = "sudo nix-collect-garbage -d";
      };
      extraConfig = ''
        $env.config.show_banner = false;
        $env.config.shell_integration = true;
      '';
    };
    git = {
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
  };
}
