{ config, flake-self, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.laptop;
in {
  options.link.laptop = { enable = mkEnableOption "activate laptop"; };
  config = mkIf cfg.enable {
    link.desktop.enable = true;
    link.hardware.enable = true;
    #options.type = "laptop";
    #networking.wireless.enable = !config.networking.networkmanager.enable;
    networking.networkmanager = {
      enableStrongSwan = true;
      wifi.macAddress = "stable";
    };
    hardware.bluetooth.enable = true;
    services.xserver.libinput.enable = true;
    services.auto-cpufreq.enable = true; # TLP replacement
    services.auto-cpufreq.settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
}