{ config, pkgs, lib, ... }:

let 
  username = "piankris";
  homeDirectory = "/home/${username}";
  nullPackage = name: pkgs.writeShellScriptBin name "";
in
{
  home = {
    inherit username homeDirectory;
    stateVersion = "22.05";
    packages = [
      pkgs.lsd
      pkgs.bat
      pkgs.nerdfonts
      pkgs.joypixels
    ];
    shellAliases = {
      ls="lsd -la";
      lsd="lsd -la";
      rm="rm -f";
      home="code ~/.config/nixpkgs/home.nix";
    };
  };
  fonts.fontconfig.enable = true;

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
