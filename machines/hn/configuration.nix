{ self, ... }:
{ pkgs, lib, config, flake-self, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
  ];
  home-manager.users.l = flake-self.homeConfigurations.convertible;
  link = {
    convertible.enable = true;
    main.enable = true;
    cpu-intel.enable = true;
    nvidia.enable = true;
  };
  networking.hostName = "hn";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ]; # Is this needed?
  environment.systemPackages = with pkgs;    [ ];
  #system.stateVersion = "23.05";

}
