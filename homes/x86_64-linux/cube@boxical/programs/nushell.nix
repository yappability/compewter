{ pkgs, ... }: {
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
}
