{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.common.linkding;
in
{
  options.common.linkding = {
    enable = mkEnableOption "Enable Linkding";
    workingDir = mkOption {
      type = types.str;
      default = "/var/lib/linkding";
      description = "Path to Linkding config files";
    };
    port = mkOption {
      type = types.str;
      default = "9090";
      description = "Port for linkding to be advertised on";
    };
    nginx = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable nginx reverse proxy with SSL";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      backend = "docker";
      containers."linkding" = {
        autoStart = true;
        image = "sissbruecker/linkding:latest";
        ports = [ "${cfg.port}:9090" ];
        volumes = [
          "${cfg.workingDir}/data:/etc/linkding/data"
        ];
      };
    };

    services.nginx = mkIf cfg.nginx {
      virtualHosts."linkding.pve.elmurphy.com"= {
        enableACME = true;
        addSSL = true;
        acmeRoot = null;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${cfg.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
