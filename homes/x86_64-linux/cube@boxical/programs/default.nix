{ ... }: {
  imports = [ ./git.nix ./vesktop.nix ./nushell.nix ];

  programs = {
    firefox.enable = true;
    vscode.enable = true;
    obs-studio.enable = true;
    # bun = {
    #   enable = true;
    #   package = pkgs.me.bun;
    # };

    nix-index-database.comma.enable = true;
  };
}
