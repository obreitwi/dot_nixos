# utility functions to be used
{
  vimLua = str: ''
    lua <<EOF
    ${str}
    EOF
  '';
}
