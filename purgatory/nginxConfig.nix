sslCert: sslKey:
let
  extraCfg = "proxy_ssl_server_name on; proxy_pass_header Authorization;";
  vhMain = {
    onlySSL = true;
    sslCertificate    = sslCert;
    sslCertificateKey = sslKey;
    locations."/zehnerRaus" = {
      proxyPass = "http://127.0.0.1:444";
      proxyWebsockets = true;
      extraConfig = extraCfg + " rewrite /zehnerRaus/(.*) /$1 break;";
    };
    locations."/" = {
      proxyPass = "http://127.0.0.1:445";
      extraConfig = extraCfg;
    };
  };
in {
  enable = true;
  user = "root";
  group = "root";
  recommendedProxySettings = true;
  recommendedTlsSettings = true;
  appendConfig = "user root;";
  virtualHosts = {
    "samuwe.com"      = vhMain;
    "www.samuwe.com"  = vhMain;
    "samalws.com"     = vhMain;
    "www.samalws.com" = vhMain;
  };
}
