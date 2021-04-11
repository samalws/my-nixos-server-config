{ pkgs, ... }:
let
  sslCert = "/etc/letsencrypt/live/samuwe.com/fullchain.pem";
  sslKey  = "/etc/letsencrypt/live/samuwe.com/privkey.pem";
in {
  imports = (import ./imports.nix);

  networking = (import ./networkConfig.nix);
  users.users = (import ./userConfig.nix);
  systemd.services = (import ./systemdConfig.nix) pkgs;
  mailserver = (import ./mailserverConfig.nix) sslCert sslKey;
  services.vsftpd = (import ./ftpConfig.nix) sslCert sslKey;
  services.nginx = (import ./nginxConfig.nix) sslCert sslKey;

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  environment.systemPackages = with pkgs; [
    vim
    st
    git
  ];

  system.stateVersion = "20.09";
}
