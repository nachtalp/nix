{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.jitsi;
in {
  options.link.jitsi.enable = mkEnableOption "activate jitsi";
  config = mkIf cfg.enable {
    services = {
      jitsi-meet = {
        enable = true;
        hostName = "jitsi.${config.link.domain}";
        nginx.enable = config.link.nginx.enable;
        interfaceConfig = {
          SHOW_JITSI_WATERMARK = false;
          SHOW_WATERMARK_FOR_GUESTS = false;
        };
        config = {
          authdomain = "jitsi.${config.link.domain}";
          enableInsecureRoomNameWarning = true;
          fileRecordingsEnabled = false;
          liveStreamingEnabled = false;
          prejoinPageEnabled = true;
        };
        videobridge.enable = true;
        prosody.enable = true;
        jicofo.enable = true;
        jibri.enable = true;
      };
      jitsi-videobridge = {
        enable = true;
        openFirewall = true;
      };
      jicofo = {
        enable = true;
        config = { "org.jitsi.jicofo.auth.URL" = "XMPP:jitsi.${config.link.domain}"; };
      };
      nginx.virtualHosts = mkIf config.link.nginx.enable {
        "jitsi.${config.link.domain}" = {
          enableACME = true;
          forceSSL = true;
        };
      };
    };
  };
}
