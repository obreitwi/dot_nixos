{
  config,
  pkgs,
  ...
}: let
  gitconfig = builtins.readFile ./gitconfig;
  gitconfig_private =
    pkgs.writeText "gitconfig_private"
    /*
    gitconfig
    */
    ''
      [user]
      email = oliver@breitwieser.eu
      name = Oliver Breitwieser
      signingkey = BF1B0895E8BD4A52
    '';
in {
  home.file.".gitconfig".text =
    /*
    gitconfig
    */
    ''
      [includeIf "gitdir:~/git/"]
        path = ${gitconfig_private}
      [includeIf "gitdir:~/projects/"]
        path = ${gitconfig_private}
    ''
    + gitconfig;

  home.packages = [pkgs.git];

  # taken from https://github.com/nix-community/home-manager/issues/2765#issuecomment-1054129334
  systemd.user = {
    services = let
      serviceCommand = {
        name,
        command,
      }: {
        Unit = {
          Wants = "${name}.timer";
        };
        Service = {
          Type = "oneshot";
          ExecStart = command;
        };
        Install = {
          WantedBy = ["multi-user.target"];
        };
      };
      serviceGit = {time}:
        serviceCommand {
          name = "git-${time}";
          command = "%h/.nix-profile/libexec/git-core/git --exec-path=%h/.nix-profile/libexec/git-core for-each-repo --config=maintenance.repo maintenance run --schedule=${time}";
        };
    in {
      git-hourly = serviceGit {time = "hourly";};
      git-daily = serviceGit {time = "daily";};
      git-weekly = serviceGit {time = "weekly";};
    };

    timers = let
      timer = {
        name,
        onCalendar,
      }: {
        Unit = {
          Requires = "${name}.service";
        };
        Timer = {
          OnCalendar = onCalendar;
          AccuracySec = "12h";
          Persistent = true;
        };
        Install = {
          WantedBy = ["timers.target"];
        };
      };
    in {
      git-hourly = timer {
        name = "git-hourly";
        onCalendar = "hourly";
      };
      git-daily = timer {
        name = "git-daily";
        onCalendar = "hourly";
      };
      git-weekly = timer {
        name = "git-weekly";
        onCalendar = "weekly";
      };
    };
  };
}
