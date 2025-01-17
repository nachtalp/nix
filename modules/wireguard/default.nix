{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.wireguard;
in {
  options.link.wireguard.enable = mkEnableOption "activate wireguard";
  config = mkIf cfg.enable {
    networking = {
      wireguard.enable = true;
      nat = {
        enable = true;
        enableIPv6 = true;
      };
      firewall = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 51820 ];
        logReversePathDrops = true;
      };
      # if packets are still dropped, they will show up in dmesg
      # wireguard trips rpfilter up
      # extraCommands = ''
      #   ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
      #   ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
      # '';
      # extraStopCommands = ''
      #   ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
      #   ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
      # '';
    };
    # services = {
    #   dnsmasq = {
    #     enable = true;
    #     extraConfig = ''
    #       interface=wg-deep
    #     '';
    #   };
    # };
  };
}
