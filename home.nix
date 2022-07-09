{ config, pkgs, lib, ... }:

let 
  username = "delphai";
  homeDirectory = "/home/${username}";
  nullPackage = name: pkgs.writeShellScriptBin name "";
in
{
  home = {
    inherit username homeDirectory;
    stateVersion = "22.05";
    sessionVariables = {
      TERMINAL = "kitty";
      BROWSER = "brave";
      EDITOR = "code";
    };
    sessionPath = [
      "${homeDirectory}/.pyenv/bin"
    ];
    packages = [
      pkgs.lsd
      pkgs.bat
      pkgs.nerdfonts
    ];
    shellAliases = {
      ls="lsd -la";
      lsd="lsd -la";
      rm="rm -f";
      home="code ~/.config/nixpkgs/home.nix";
    };
  };
  fonts.fontconfig.enable = true;

  programs.kitty = {
    enable = true;
    package = nullPackage "kittyNull";
    theme = "Tokyo Night Storm";
    font = {
      name = "Fira Code Nerd Font";
      size = 12;
    };
    extraConfig = ''
      allow_remote_control yes
      background_opacity 0.93
      # background_image ${homeDirectory}/nord_valley1.png
      # background_image_opacity 0.9
      # background_image_layout scaled
      linux_display_server x11

      # foreground            #D8DEE9
      # background            #2E3440
      # selection_foreground  #000000
      # selection_background  #FFFACD
      # url_color             #0087BD
      # cursor                #81A1C1

      # # black
      # color0   #3B4252
      # color8   #4C566A

      # # red
      # color1   #BF616A
      # color9   #BF616A

      # # green
      # color2   #A3BE8C
      # color10  #A3BE8C

      # # yellow
      # color3   #EBCB8B
      # color11  #EBCB8B

      # # blue
      # color4  #81A1C1
      # color12 #81A1C1

      # # magenta
      # color5   #B48EAD
      # color13  #B48EAD

      # # cyan
      # color6   #88C0D0
      # color14  #8FBCBB

      # # white
      # color7   #E5E9F0
      # color15  #ECEFF4

      map kitty_mod+p next_window # kitty_mod : shift + cntrl
    '';
    settings = {
      window_padding_width = "8 8";
    };
  };

#   programs.git = {
#     enable = true;
#     userName = "Kristina Pianykh";
#     userEmail = "kristinavrnrus@gmail.com";
#     diff-so-fancy.enable = true;
#     includes = [
#       { 
#         condition = "gitdir:${directories.delphai.path}/";
#         contents = {
#           user = {
#             name = "Kristina Pianykh";
#             email = "kristina@delphai.com";
#           };
#         };
#       }
#     ];
#   };

  programs.starship = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    history.extended = true;
    dotDir = ".config/zsh";
    initExtraFirst = ''
      export PYENV_ROOT="$HOME/.pyenv"
      command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init -)"
    '';
    prezto = {
      enable = true;
      extraConfig = ''
        # alias node="nocorrect node"
        # alias yarn="nocorrect yarn"
      '';
      pmodules = [
        "environment"
        "terminal"
        "history"
        "directory"
        "spectrum"
        "utility"
        "completion"
      ];
    };
  };
  programs.home-manager.enable = true;
}