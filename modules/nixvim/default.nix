{
  imports = [
    ./colorscheme.nix
    ./directories.nix
    ./keymaps.nix
    ./lsp.nix
    ./powersettings.nix
    ./prefix_maps.nix
    ./spelling.nix
    ./statusline.nix
    ./syntax.nix

    ./lang
    ./plugins
  ];

  clipboard.providers.xclip.enable = true;

  opts = {
    number = true;
    relativenumber = true;
    encoding = "utf8";
    shada = "!,'1000,<50,s10,h";
    compatible = false;
    foldlevelstart = 99;

    splitright = true;

    hidden = true;
    wrap = false;

    linebreak = true;
    showbreak = "↳ ";
    list = true;
    virtualedit = "all";
    lazyredraw = true; # do not update screen while executing macros
    ttyfast = true; # are we using a fast terminal? Let's try it for a while.
    cul = true;
    timeoutlen = 500; # set timeoutlen=250
    scrolloff = 4;

    gdefault = true;

    sessionoptions = "blank,curdir,tabpages,folds,resize";

    backspace = "indent,eol,start"; # make backspace work

    smarttab = true;
    autoindent = false;
    smartindent = true;
    incsearch = true;
    hlsearch = true;
    ignorecase = true;
    smartcase = true; # case only matters if search contains upper case letters

    # expandtab = true; disabled because it should be set by plugin
    tabstop = 4;
    softtabstop = 4;
    shiftwidth = 4;
    shiftround = true;

    completeopt = "menu,menuone,preview,noinsert,noselect";

    wildmenu = true;
    wildmode = "list,full";

    # IMPORTANT: grep will sometimes skip displaying the file name if you
    # search in a singe file. This will confuse Latex-Suite. your grep
    # program to always generate a file-name.
    grepprg = "grep\ -nH\ $*";

    # read files in automatically
    autoread = true;

    # Options for diff mode
    diffopt = "filler,vertical,context:10,internal,indent-heuristic,closeoff,linematch:100";

    # see 'fo-table'
    formatoptions = "njcroql";
    formatlistpat = "^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*\\\|^\\s*\\*\\s\\?";

    # Use only 1 space after "." when joining lines instead of 2
    joinspaces = false;

    listchars = "tab:▸·,extends:⇉,precedes:⇇,nbsp:·,eol:↵,trail:␣";
  };

  globals = {
    mapleader = " ";
    maplocalleader = ";";
  };
}
