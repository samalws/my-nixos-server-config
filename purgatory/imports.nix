let
  release = "nixos-20.09";
in [
  /etc/nixos/hardware-configuration.nix
  (builtins.fetchTarball {
     url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${release}/nixos-mailserver-${release}.tar.gz";
     sha256 = "0vsvgxxg5cgmzwj98171j7h5l028f1yq784alb3lxgbk8znfk51y";
   })
]
