{ inputs, pkgs, system, lib, ... }: {
  imports = [
    # Include the packages.
    ./packages.nix
    # Include the program settings.
    ./programs
  ];

  home.stateVersion = "24.05";
}
