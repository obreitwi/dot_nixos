{
  config,
  pkgs,
  ...
}: let
  gitconfig = builtins.readFile ./gitconfig;
  gitconfig_private =
    pkgs.writeText "gitconfig_private"
    # gitconfig
    ''
      [user]
      email = oliver@breitwieser.eu
      name = Oliver Breitwieser
      signingkey = BF1B0895E8BD4A52
    '';

  hooks.prepare-commit-msg = pkgs.writeShellApplication {
    name = "prepare-commit-msg";
    runtimeInputs = [pkgs.gawk];
    text = ''
      COMMIT_MSG_FILE=$1
      # COMMIT_SOURCE=$2
      # SHA1=$3

      if grep -iq "^\(Jira\|^Rev\):" "$COMMIT_MSG_FILE"; then
        # Story IDs exist, no need to do anything
        exit 0
      fi

      id=$(git branch --show-current | cut -d / -f 2 | grep "[A-Z]\+-[A-Z0-9]\+" || true)
      if [ -z "$id" ]; then
        # branch-name does not contain valid rev/jira id -> cannot add
        exit 0
      fi

      gawk -v "id=Rev: ''$id" '/^#/ { if (added==0) { printf "%s\n", id; added=1 } } { print } END { if (added=0) { print id } }' <"$COMMIT_MSG_FILE" >"''${COMMIT_MSG_FILE}.tmp"

      mv "''${COMMIT_MSG_FILE}.tmp" "$COMMIT_MSG_FILE"
    '';
  };

  hooksFolder = pkgs.linkFarm "hooks" [
    {
      name = "prepare-commit-msg";
      path = "${hooks.prepare-commit-msg}/bin/prepare-commit-msg";
    }
  ];
in {
  home.file.".gitconfig".text =
    # gitconfig
    ''
      [includeIf "gitdir:~/git/"]
        path = ${gitconfig_private}
      [includeIf "gitdir:~/projects/"]
        path = ${gitconfig_private}
      [core]
        hooksPath = ${hooksFolder}
    ''
    + gitconfig;

  home.packages = [
    pkgs.delta
    pkgs.difftastic
    pkgs.git
  ];

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
