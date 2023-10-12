{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {

  imports = [ ./common.nix ];
  config = {
    home.packages = with pkgs;
      [
        # Desktop monitor settings change
        ddcui
        ddcutil
        hddtemp
        powertop
        lshw
        usbutils

      ] ++ lib.optionals
      (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [ ];
  };

}