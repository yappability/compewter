{ config, pkgs, inputs, ... }:

{
  users.users.cube = {
    # My user account
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "video" "audio" ];
    initialHashedPassword =
      "$y$j9T$UuBTG5po4wc55.FJ3lKCO1$.ZTrGirfv.tR/GkRr.B18JehUGvVFf/d3E1aWJpxSE7";
    shell = pkgs.nushell;
  };
}
