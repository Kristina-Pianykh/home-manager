{
  pkgs,
  config,
  ...
}: {
  programs.kitty = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "kitty-wrapped";
      paths = [pkgs.kitty];
      postBuild = let
        binWrapped = pkgs.writeShellScript "kitty-bin-wrapped" ''
          ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.kitty}/bin/kitty $@
        '';
      in ''
        rm $out/bin/kitty
        ln -s ${binWrapped} $out/bin/kitty
      '';
    };
    font = {
      name = "FiraCode Nerd Font";
      size = 14;
    };
    keybindings = {
      "Alt+enter" = "new_window_with_cwd";
      "Alt+d" = "close_window";
      "Alt+j" = "next_window";
      "Alt+k" = "previous_window";
      "Alt+s" = "next_layout";
    };
    theme = "Rosé Pine";
    settings = {
      enabled_layouts = "tall,vertical";
      shell = "${config.programs.zsh.package}/bin/zsh";
      window_padding_width = 10;
      confirm_os_window_close = 0;
      # background = "#2e3440";
      # foreground = "#cdcecf";
      # selection_background = "#3e4a5b";
      # selection_foreground = "#cdcecf";
      # cursor_text_color = "#2e3440";
      # url_color = "#a3be8c";
      # cursor = "#cdcecf";
      #
      # # Border
      # active_border_color = "#81a1c1";
      # inactive_border_color = "#5a657d";
      # bell_border_color = "#c9826b";
      #
      # # Tabs
      # active_tab_background = "#81a1c1";
      # active_tab_foreground = "#232831";
      # inactive_tab_background = "#3e4a5b";
      # inactive_tab_foreground = "#60728a";
      #
      # # normal
      # color0 = "#3b4252";
      # color1 = "#bf616a";
      # color2 = "#a3be8c";
      # color3 = "#ebcb8b";
      # color4 = "#81a1c1";
      # color5 = "#b48ead";
      # color6 = "#88c0d0";
      # color7 = "#e5e9f0";
      #
      # # bright
      # color8 = "#465780";
      # color9 = "#d06f79";
      # color10 = "#b1d196";
      # color11 = "#f0d399";
      # color12 = "#8cafd2";
      # color13 = "#c895bf";
      # color14 = "#93ccdc";
      # color15 = "#e7ecf4";
      #
      # # extended colors
      # color16 = "#c9826b";
      # color17 = "#bf88bc";
    };
  };
}
