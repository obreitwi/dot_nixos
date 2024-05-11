# utility functions to be used
{
  toLua = str: ''
    lua <<EOF
    ${str}
    EOF
  '';
}
