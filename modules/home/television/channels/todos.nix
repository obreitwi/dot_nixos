{pkgs, ...}: let
  todos-list = pkgs.writeShellApplication {
    name = "todos-list";
    text = ''
      find ~/wiki/neorg/journal -mindepth 1 -maxdepth 1 -type f \
        | sort -r \
        | xargs grep -n '^\s*\(\*\|-\) \(( )\|\[[ .oO]\]\)' \
        | sed -e 's/\(\*\|-\) \(( )\|\[ \]\) \s*//g' -e 's/ %#taskid[^%]*%//g'
    '';
  };
in {
  programs.television.channels.todos = {
    metadata = {
      description = "Select todo entry";
      name = "todos";
    };
    preview = {
      command = "${pkgs.bat}/bin/bat --color always -l markdown '{split:::0}' -H {split:::1}";
    };
    source = {
      command = "${todos-list}/bin/todos-list";
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
    "tedos" = "tv todos";
  };
}
