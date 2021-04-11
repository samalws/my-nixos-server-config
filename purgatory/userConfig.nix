let
  sshKeys = (import ./sshKeys.nix);
in {
  uwe = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = sshKeys.uwe;
  };
  git = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = sshKeys.git;
  };
}
