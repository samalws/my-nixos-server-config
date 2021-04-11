pkgs: desc: folder: {
  description = desc;
  serviceConfig = {
    Type = "simple";
    WorkingDirectory = "/home/uwe/heaven/${folder}";
    ExecStart = "${pkgs.nodejs}/bin/node server.js";
  };
  after = ["network.target"];
  wantedBy = ["multi-user.target"];
  enable = true;
}
