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
    packages = with pkgs; [
      lsd
      bat
      nerdfonts
      joypixels
      awscli
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
  
  programs.git = {
  enable = true;
  userName = "Kristina Pianykh";
  userEmail = "kristina.pianykh@diconium.com";
  signing = {
    key = "3A09BEC8E7DCA833";
    gpgPath = "/usr/bin/gpg";
    signByDefault = true;
  };
  diff-so-fancy.enable = true;
  extraConfig = {
    init = {
        defaultBranch = "main";
    };
  };
  includes = [
  { 
    condition = "gitdir:${homeDirectory}/Private/";
    contents = {
      user = {
        name = "Kristina Pianykh";
        email = "kristinavrnrus@gmail.com";
        signingKey = "C66C7DFC66E169F1";
      };
      commit = {
        gpgSign = true;
      };
    };
  }
  ];
  };
}
