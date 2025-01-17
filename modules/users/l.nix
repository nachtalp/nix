{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.users.l;
in {

  options.link.users.l = { enable = mkEnableOption "activate user l"; };

  config = mkIf cfg.enable {

    users.users.l = {
      isNormalUser = true;
      home = "/home/l";
      extraGroups = [ "wheel" "adbusers" "audio" "plugdev" "docker" "wireshark" "video" ]
        ++ lib.optionals config.networking.networkmanager.enable
        [ "networkmanager" ];
      shell = "${pkgs.zsh}/bin/zsh";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/1eePE6/pYo4aahzcDRqbmnVdx9ikKH+93yw7M1pXH l@xn"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDF+rCKg9anv0pU96BL0cUcbKU8w1q75kt+JGroJcE19 l@sn"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINI74luZ3xJcgaZYHzn5DtSpYufml+SbhZQV12gWGShS l@dn"
      ];
      hashedPassword = "$6$rounds=1000000$yacdewvoirbidab$4nws4XniUU045W/KXkOpKd390HfXFfYU0wkBWy3zAMNTrg22R4eyyGq8QYzIWor3w4Uf.DT61AdBfl77DHZDu0";
    };
    nix.settings.allowed-users = [ "l" ];
  };

}
