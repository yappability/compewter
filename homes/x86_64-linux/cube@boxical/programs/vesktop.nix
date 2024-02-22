{ pkgs, lib, ... }: {
  programs.vesktop = {
    enable = true;
    package = lib.me.patchOutput pkgs.me.vesktop ''
      rm -r $out/share/icons
      mkdir -p $out/share/icons/hicolor/scalable/apps/
      cp ${
        ../icons/vesktop.svg
      } $out/share/icons/hicolor/scalable/apps/vesktop.svg
    '';
  };
}
