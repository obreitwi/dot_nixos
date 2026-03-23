{pkgs, ...}: let
  journal-list = pkgs.writeShellApplication {
    name = "journal-list-sections";
    text = ''
      grep -rHn '^\* ' ~/wiki/neorg/journal | grep -v '\* \(TODOs\?\( eod\)\?\|Time log\)$' | sort -r | sed -e 's;\* ;;g'
      find ~/wiki/neorg/projects -type f -name "*.norg" | sort | while read -r journal_item; do
        echo "''${journal_item}:1:$(basename "''${journal_item}" | sed -e 's/\.norg$//')"
      done
    '';
  };

  journal-preview = pkgs.writeShellApplication {
    name = "journal-preview";
    text = ''
      file=''$1
      line=''$2

      lines_until_next=$(tail -n "+$((line + 1))" "''${file}" | grep -n '^\* ' | head -n 1 | cut -d : -f 1)

      if [ -z "''${lines_until_next}" ]; then
        lines_until_next=$(( $(wc -l < "''${file}") - line))
      else
        (( lines_until_next -= 1 ))
      fi
      ${pkgs.bat}/bin/bat --color always --language markdown -r "''${line}:+''${lines_until_next}" "''${file}"
    '';
  };
in {
  programs.television.channels.journal = {
    metadata = {
      description = "Select journal entry";
      name = "journal";
    };
    preview = {
      # NOTE: Markdown is stop-gap, we want neorg highlting
      command = "${journal-preview}/bin/journal-preview '{split:::0}' {split:::1}";
    };
    source = {
      command = "${journal-list}/bin/journal-list-sections";
      display = "{split:::2..}";
      no_sort = true;
    };

    actions = {
      edit = {
        description = "Open selected files in editor";
        command = "nvim {split:::0} +{split:::1}";
      };
    };
    keybindings = {
      enter = "actions:edit";
    };
  };

  programs.zsh.shellAliases = {
    "tournal" = "tv journal";
  };
}
