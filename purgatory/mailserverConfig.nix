sslCert: sslKey:
{
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
}
