{ inputs, config, osConfig, lib, pkgs, ... }: {
  config = lib.mkIf config.programs.firefox.enable {
    programs.firefox = {
      package =
        inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin.override {
          cfg = {
            enableGnomeExtensions =
              osConfig.services.xserver.desktopManager.gnome.enable;
            enablePlasmaBrowserIntegration =
              osConfig.services.xserver.desktopManager.plasma5.enable;
          };
        };
      profiles.default = {
        isDefault = true;
        name = "default";
        id = 0;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
          "browser.theme.dark-private-windows" = false;
          "gnomeTheme.hideSingleTab" = true;
          "gnomeTheme.hideWebrtcIndicator" = true;
        };
      };
    };
  };
}
