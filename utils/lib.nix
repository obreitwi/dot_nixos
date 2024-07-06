# utility functions to be used
{
  vimLua = str: ''
    lua <<EOF
    ${str}
    EOF
  '';

  getDomain = lib: hostName: let
    l = lib.lists;
    s = lib.strings;
  in
    s.concatStringsSep "." (l.drop 1 (s.splitString "." hostName));

  nginxACME = domain: {
    forceSSL = true;
    sslCertificate = "/var/lib/acme/${domain}/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/${domain}/key.pem";
    sslTrustedCertificate = "/var/lib/acme/${domain}/chain.pem";
  };
}
