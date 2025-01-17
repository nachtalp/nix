{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.nextcloud;
in {
  options.link.nextcloud.enable = mkEnableOption "activate nextcloud";
  config = mkIf cfg.enable {
    services = {
      nextcloud = {
        enable = true;
        hostName = if config.link.nginx.enable then "nextcloud.${config.link.domain}" else config.networking.hostName;
        config = {
          adminuser = "l";
          adminpassFile = "${config.link.secrets}/nextcloud";
        };
        #secretFile = "${config.link.secrets}/nextcloud-secrets.json";
        extraApps = with config.services.nextcloud.package.packages.apps; {
          inherit bookmarks calendar contacts deck keeweb mail news notes
            onlyoffice polls tasks twofactor_webauthn;
        };
        #extraOptions = {
        #  mail_smtpmode = "sendmail";
        #  mail_sendmailmode = "pipe";
        #};
        extraAppsEnable = true;
        autoUpdateApps.enable = true;
        appstoreEnable = true;
        https = true;
        configureRedis = true;
        database.createLocally = true;
        home = "${config.link.storage}/nextcloud";
      };
      nginx.virtualHosts."nextcloud.${config.link.domain}" = mkIf config.link.nginx.enable {
        enableACME = true;
        forceSSL = true;
        #locations."/" = {
        #  proxyPass = "http://127.0.0.1:80/";
        # extraConfig = ''
        #   proxy_set_header Front-End-Https on;
        #   proxy_set_header Strict-Transport-Security "max-age=2592000; includeSubdomains";
        #   proxy_set_header X-Real-IP $remote_addr;
        #   proxy_set_header Host $host;
        #   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        #   proxy_set_header X-Forwarded-Proto $scheme;
        # '';
        #};
      };
    };
  };
}
