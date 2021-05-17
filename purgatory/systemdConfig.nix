pkgs: let
  nodeService = (import ./nodeService.nix) pkgs;
in {
  forwardHttp = nodeService "forward http to https service" "forward-http";
  myWebsite = nodeService "host samalws.com-3" "my-website";
  wopallaHost = nodeService "host wopalla.com" "wopalla-host";
  zehnerRaus = nodeService "zehner raus service" "zehner-raus/server";
}
