{ config, pkgs, inputs, ... }:

{
  imports = [
    # Import all the active user configurations
    ./cube.nix
  ];

  users.mutableUsers = false;
  environment.shells = with pkgs; [ nushell ];
}
