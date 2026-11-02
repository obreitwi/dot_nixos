# home-manager config baked into the agent-base docker image (see docker/agent-base)
{pkgs, ...}: {
  imports = [
    ../../modules/home/pi-coding-agent
  ];

  home.username = "agent";
  home.homeDirectory = "/home/agent";
  home.stateVersion = "23.11";

  # available to every agent (pi gets git via its wrapper as well)
  home.packages = [
    pkgs.claude-code
    pkgs.gh
    pkgs.git

    # basic utilities (the base image ships only a few)
    pkgs.bzip2
    pkgs.coreutils
    pkgs.diffutils
    pkgs.fd
    pkgs.file
    pkgs.findutils
    pkgs.gawk
    pkgs.gnugrep
    pkgs.gnused
    pkgs.jq
    pkgs.less
    pkgs.patch
    pkgs.procps
    pkgs.ripgrep
    pkgs.which

    # unzip utils disabled because not necessary for development work
    #pkgs.gnutar
    #pkgs.gzip
    #pkgs.unzip
    #pkgs.xz
    #pkgs.zip
  ];

  my.pi-coding-agent = {
    enable = true;
    bedrock.enable = true;
    devPackages = true;
    inContainer = true;
  };
}
