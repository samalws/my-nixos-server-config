{ config, pkgs, ... }:
let
  ssh_keys = (import ./ssh_keys.nix);
  release = "nixos-20.09";
in {
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      (builtins.fetchTarball {
         url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${release}/nixos-mailserver-${release}.tar.gz";
         sha256 = "0vsvgxxg5cgmzwj98171j7h5l028f1yq784alb3lxgbk8znfk51y";
       })
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };

  networking = {
    hostName = "uwe-land";
    useDHCP = false;
    firewall.enable = false;
    interfaces = {
      ens3.useDHCP = true;
      ens7.useDHCP = true;
    };
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  users.users = {
    uwe = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = ssh_keys.uwe;
    };
    git = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = ssh_keys.git;
    }; 
  };

  systemd.services.forwardHttp = {
    description = "forward http to https service";
    serviceConfig = {
      Type = "forking";
      ExecStart = ''/home/uwe/purgatory/nodeService /home/uwe/heaven/forward-http ${pkgs.nodejs}/bin/node'';
    };
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
  };
  systemd.services.forwardHttp.enable = true;

  systemd.services.myWebsite = {
    description = "host samalws.com-3";
    serviceConfig = {
      Type = "forking";
      ExecStart = ''/home/uwe/purgatory/nodeService /home/uwe/heaven/my-website ${pkgs.nodejs}/bin/node'';
    };
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
  };
  systemd.services.myWebsite.enable = true;

  systemd.services.zehnerRaus = {
    description = "zehner raus service";
    serviceConfig = {
      Type = "forking";
      ExecStart = ''/home/uwe/purgatory/nodeService /home/uwe/heaven/zehner-raus/server ${pkgs.nodejs}/bin/node'';
    };
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
  };
  systemd.services.zehnerRaus.enable = true;

  mailserver = {
    enable = true;
    fqdn = "samuwe.com";
    domains = [ "samuwe.com" "samalws.com" ];

    # A list of all login accounts. To create the password hashes, use
    # nix run nixpkgs.apacheHttpd -c htpasswd -nbB "" "super secret password" | cut -d: -f2
    loginAccounts = {
        "uwe@samuwe.com".hashedPasswordFile = "/home/uwe/purgatory/mailPassHashed";
        "sam@samalws.com".hashedPasswordFile = "/home/uwe/purgatory/mailPassHashed";
    };
    certificateScheme = 1;
    certificateFile = "/etc/letsencrypt/live/samuwe.com/fullchain.pem";
    keyFile         = "/etc/letsencrypt/live/samuwe.com/privkey.pem";
  };

  services.vsftpd = {
    enable = true;
    localUsers = true;
    userlist = [ "uwe" ];
    userlistEnable = true;
    forceLocalLoginsSSL = true;
    forceLocalDataSSL = true;
    rsaCertFile = "/etc/letsencrypt/live/samuwe.com/fullchain.pem";
    rsaKeyFile = "/etc/letsencrypt/live/samuwe.com/privkey.pem";
  };

  services.nginx = {
    enable = true;
    config = import ./nginxconf.nix;
    user = "root";
    group = "root";
  };

  environment.systemPackages = with pkgs; [
    vim
    st
    git
  ];

  system.stateVersion = "20.09";
}
