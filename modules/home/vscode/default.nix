{ inputs, pkgs, config, lib, ... }: {
  config = lib.mkIf config.programs.vscode.enable {
    home.packages = with pkgs; [ nil nixpkgs-fmt ];

    programs.vscode = {
      mutableExtensionsDir = false;
      extensions = pkgs.callPackage ./extensions.nix {
        extensions =
          (inputs.vscode-extensions.extensions.${pkgs.system}.forVSCodeVersion
            pkgs.vscode.version).vscode-marketplace;
      };
    };
  };
}
