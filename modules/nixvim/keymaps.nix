{ lib, ... }:
{
  globals = {
    mapleader = " ";
    maplocalleader = ";";
  };

  keymaps =
    [
      {
        key = "gr"; # great reset
        mode = "n";
        action = ":resize 200<CR><c-w>=";
      }

      # time stamp insertion
      {
        key = "<C-D><C-E>";
        action = ''<C-R>=strftime("%d.%m.%Y %H:%M:%S")<CR>'';
        mode = "i";
      }
      {
        key = "<C-D><C-D>";
        action = ''<C-R> --obreitwi, <C-R>=strftime("%d-%m-%y %H:%M:%S")<CR>'';
        mode = "i";
      }
      {
        key = "<C-D><C-F>";
        action = ''<C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>'';
        mode = "i";
      }
      {
        key = "<C-D><C-R>";
        action = ''<C-R>=strftime("%Y/%m/%d")<CR>'';
        mode = "i";
      }
      {
        key = "<C-D><C-W>";
        action = ''C-R>=strftime("%Y-%m-%d")<CR>'';
        mode = "i";
      }

      # searching
      {
        key = "<C-U>";
        mode = "n";
        action = ":nohl<CR>";
      }
      {
        key = "<C-U>";
        mode = "i";
        action = "<c-o>:nohl<CR>";
      }
      {
        key = "n";
        mode = "n";
        action = "nzz";
      }
      {
        key = "N";
        mode = "n";
        action = "Nzz";
      }
      {
        key = "M";
        mode = "n";
        action = "J";
      }
      {
        key = "J";
        mode = "n";
        action = "M";
      }

      # navigation
      {
        key = "j";
        action = "(v:count == 0 ? 'gj' : 'j')";
        mode = "n";
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        key = "k";
        action = "(v:count == 0 ? 'gk' : 'k')";
        mode = "n";
        options = {
          expr = true;
          silent = true;
        };
      }

      # Disable annoying insert-mode bindings
      {
        key = "<c-w>";
        action = "<nop>";
        mode = "i";
      }
      {
        key = "<c-h>";
        action = "<nop>";
        mode = "i";
      }
      {
        key = "L";
        action = "<nop>";
      }

      {
        key = "<c-e><c-h>";
        action = ":tabp<CR>";
      }
      {
        key = "<c-e><c-l>";
        action = ":tabn<CR>";
      }

      # TODO: The following mapping deletes the whole buffer
      # -> figure out which text-object is called here, for now: disable
      {
        key = "cie";
        action = "<nop>";
        mode = "n";
      }
    ]
    ++ (
      [
        "K"
        "J"
      ]
      |> map (key: {
        inherit key;
        mode = [
          "n"
          "v"
        ];
        action = "8" + (lib.toLower key);
        options.remap = true;
      })
    )
    ++ (
      [
        {
          key = "<c-q>";
          action = "<c-u>zz";
        }
        {
          key = "<c-f>";
          action = "<c-u>zz";
        }
        {
          key = "<c-d>";
          action = "<c-d>zz";
        }
      ]
      |> (builtins.concatMap (
        {
          key,
          action,
        }:
        [
          "n"
          "i"
          "x"
        ]
        |> (map (mode: {
          inherit key action mode;
        }))
      ))
    );
}
