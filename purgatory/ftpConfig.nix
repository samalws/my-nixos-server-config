sslCert: sslKey:
{
  enable = true;
  localUsers = true;
  userlist = [ "uwe" ];
  userlistEnable      = true;
  forceLocalLoginsSSL = true;
  forceLocalDataSSL   = true;
  rsaCertFile = sslCert;
  rsaKeyFile  = sslKey;
}
