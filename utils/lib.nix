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
}
