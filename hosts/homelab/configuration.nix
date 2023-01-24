{ lib, config, pkgs, inputs, ... }:

let
  impermanence = builtins.fetchTarball {
    url = "https://github.com/nix-community/impermanence/archive/master.tar.gz";
  };
in
{
  imports = [
    ./hardware-configuration.nix
    inputs.impermanence.nixosModules.impermanence
    ./modules/s3fs.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  time.timeZone = "Australia/Melbourne";

  i18n.defaultLocale = "en_AU.UTF-8";
  services.xserver.layout = "us";

  users = {
    mutableUsers = false;
    groups.seedbox-sync = {};
    users = {
      mm = {
        isNormalUser = true;
        home = "/home/mm";
        passwordFile = config.age.secrets.userPass.path;
        extraGroups = [ "wheel" ];
      };
      seedbox-sync = {
        group = "seedbox-sync";
        isSystemUser = true;
        createHome = true;
        home = "/srv/seedbox-sync";
      };
    };
  };

  environment = {
    persistence."/nix/persist" = {
      directories = [
        "/etc/nixos"
        "/srv"
        "/var/log"
        "/var/lib"
        "/data"
      ];
      files = [
        "/etc/machine-id"
      ];
    };
    etc = {
      "ssh/ssh_host_rsa_key".source = "/nix/persist/etc/ssh/ssh_host_rsa_key";
      "ssh/ssh_host_rsa_key.pub".source = "/nix/persist/etc/ssh/ssh_host_rsa_key.pub";
      "ssh/ssh_host_ed25519_key".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
      "ssh/ssh_host_ed25519_key.pub".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key.pub";
    };
    systemPackages = with pkgs; [
      vim
    ];
  };

  services = {
    qemuGuest.enable = true;
    roon-server.enable = true;
    tailscale.enable = true;
    s3fs.enable = true;
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud25;
      home = "/srv/nextcloud";
      hostName = "nix-media.zonkey-goblin.ts.net";
      autoUpdateApps.enable = true;
      https = true;
      config = {
        overwriteProtocol = "https";
        dbtype = "pgsql";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql";
        dbname = "nextcloud";
        adminuser = "admin";
        adminpassFile = config.age.secrets.nextcloudPass.path;
        defaultPhoneRegion = "AU";
      };
    };    
    postgresql = {
      enable = true;
      ensureDatabases = [ "nextcloud" ];
      ensureUsers = [{
        name = "nextcloud";
        ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
      }];
    };
    nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      # generate with `sudo tailscale cert nix-media.zonkey-goblin.ts.net && sudo chmod 644 *.key`
      sslCertificate = "/etc/nixos/secrets/nix-media.zonkey-goblin.ts.net.crt";
      sslTrustedCertificate = "/etc/nixos/secrets/nix-media.zonkey-goblin.ts.net.crt";
      sslCertificateKey = "/etc/nixos/secrets/nix-media.zonkey-goblin.ts.net.key";
    };
    openssh = {
      enable = true;
      allowSFTP = false;
      kbdInteractiveAuthentication = false;
      permitRootLogin = "no";
      extraConfig = ''
        AllowTcpForwarding yes
        X11Forwarding no
        AllowAgentForwarding no
        AllowStreamLocalForwarding no
        AuthenticationMethods publickey
      '';
    };
  };

  systemd = {
    services."nextcloud-setup" = {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
    };
    services.seedbox-sync = {
      path = [
        pkgs.rsync
        pkgs.openssh
      ];
      serviceConfig = {
        User = "seedbox-sync";
        Group = "seedbox-sync";
        ProtectSystem = "full";
        ProtectHome = true;
        NoNewPriviliges = true;
        ReadWritePaths = "/data/media";
      };
      script = config.age.secrets.syncScript.path;
    };
    timers.seedbox-sync = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "seedbox-sync.service";
        OnCalendar = "hourly";
      };
    };
  };

  networking = {
    hostName = "nix-media";
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      checkReversePath = "loose";
      allowedUDPPorts = [ config.services.tailscale.port ];
      extraCommands = ''
        iptables -A nixos-fw -p tcp --source 10.77.2.0/24 -j nixos-fw-accept
        iptables -A nixos-fw -p udp --source 10.77.2.0/24 -j nixos-fw-accept
      '';
    };
  };

  security = {
    sudo.execWheelOnly = true;
    auditd.enable = true;
    audit.enable = true;
    audit.rules = [
      "-a exit,always -F arch=b64 -S execve"
    ];
  };

  nix = {
    settings.auto-optimise-store = true;
    settings.allowed-users = [ "@wheel" ];
    package = pkgs.nix;
    gc.automatic = true;
    gc.options = "--delete-older-than 7d";
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "22.11";

  age.secrets = {
    userPass.file = ../../secrets/userPass.age;
    nextcloudPass.file = ../../secrets/nextcloudPass.age;
    syncScript.file = ../../secrets/syncScript.age;
  };
}
