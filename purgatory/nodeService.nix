pkgs: desc: folder: {
  description = desc;
  serviceConfig = {
    Type = "forking";
    ExecStart = "/home/uwe/purgatory/nodeService /home/uwe/heaven/${folder} ${pkgs.nodejs}/bin/node";
  };
  after = ["network.target"];
  wantedBy = ["multi-user.target"];
  enable = true;
}
