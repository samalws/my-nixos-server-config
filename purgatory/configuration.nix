{ config, pkgs, ... }:
let
  sshKeys = (import ./sshKeys.nix);
  nodeService = (import ./nodeService.nix) pkgs;
  release = "nixos-20.09";
  sslCert = "/etc/letsencrypt/live/samuwe.com/fullchain.pem";
  sslKey  = "/etc/letsencrypt/live/samuwe.com/privkey.pem";
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
      openssh.authorizedKeys.keys = sshKeys.uwe;
    };
    git = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = sshKeys.git;
    }; 
  };

  systemd.services = {
    forwardHttp = nodeService "forward http to https service" "forward-http";
    myWebsite = nodeService "host samalws.com-3" "my-website";
    zehnerRaus = nodeService "zehner raus service" "zehner-raus/server";
  };

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
    certificateFile = sslCert;
    keyFile         = sslKey;
  };

  services.vsftpd = {
    enable = true;
    localUsers = true;
    userlist = [ "uwe" ];
    userlistEnable      = true;
    forceLocalLoginsSSL = true;
    forceLocalDataSSL   = true;
    rsaCertFile = sslCert;
    rsaKeyFile  = sslKey;
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
