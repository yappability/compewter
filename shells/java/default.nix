{ pkgs, ... }:
pkgs.mkShell {
  packages = [
    pkgs.zulu17
    pkgs.gradle
  ];
}
