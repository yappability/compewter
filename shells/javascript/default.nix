{ pkgs, ... }:
pkgs.mkShell {
  packages = [
    pkgs.nodePackages_latest.nodejs
    pkgs.nodePackages_latest.pnpm
    pkgs.me.bun
  ];
}
