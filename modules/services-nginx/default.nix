{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.nginx;
in {
  options.link.nginx.enable = mkEnableOption "activate nginx";
  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      25
      80
      143
      443
      993
      111
      2049
      4000
      4001
      4002
    ];
    networking.firewall.allowedUDPPorts = [ 111 2049 4000 4001 4002 20048 ]; # nfs
    services.
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      logError = "stderr debug";
      package = pkgs.nginxStable.override { openssl = pkgs.libressl; };
      clientMaxBodySize = "1000m";

      # sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
      # appendHttpConfig = ''
      #   # Add HSTS header with preloading to HTTPS requests.
      #   # Adding this header to HTTP requests is discouraged
      #   map $scheme $hsts_header {
      #       https   "max-age=31536000; includeSubdomains; preload";
      #   }
      #   add_header Strict-Transport-Security $hsts_header;

      #   # Enable CSP for your services.
      #   #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

      #   # Minimize information leaked to other domains
      #   add_header 'Referrer-Policy' 'origin-when-cross-origin';

      #   # Disable embedding as a frame
      #   add_header X-Frame-Options DENY;

      #   # Prevent injection of code in other mime types (XSS Attacks)
      #   add_header X-Content-Type-Options nosniff;

      #   # This might create errors
      #   proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
      # '';
    };
    security.acme = {
      acceptTerms = true;
      defaults.email = "link2502+acme@proton.me";
      # certs."ur6qwb3amjjhe15h.myfritz.net" = {
      #   dnsProvider = "inwx";
      #   # Suplying password files like this will make your credentials world-readable
      #   # in the Nix store. This is for demonstration purpose only, do not use this in production.
      #   credentialsFile = "${pkgs.writeText "inwx-creds" ''
      #     INWX_USERNAME=xxxxxxxxxx
      #     INWX_PASSWORD=yyyyyyyyyy
      #   ''}";
      # };
    };
  };
}
