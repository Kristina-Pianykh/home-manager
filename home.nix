{ config, pkgs, lib, ... }:

let 
  username = "piankris";
  homeDirectory = "/home/${username}";
  nullPackage = name: pkgs.writeShellScriptBin name "";
in
{
  home = {
    inherit username homeDirectory;
    stateVersion = "23.05";
    packages = with pkgs; [
      lsd
      bat
      nerdfonts
      joypixels
      awscli
      rustup
      parquet-tools
    ];
    sessionPath = [
      "${homeDirectory}/Work/data-delivery-backend/.venv/bin/sqlfluff"
      "${homeDirectory}/slides"
      "${homeDirectory}/act"
    ];
    shellAliases = {
      ls="lsd -la";
      lsd="lsd -la";
      rm="rm -f";
      home="code ~/.config/nixpkgs/home.nix";
      mnt="cd /mnt/c/Users/pianykri/'OneDrive - diconium GmbH'";
      desktop="cd /mnt/c/Users/pianykri/'OneDrive - diconium GmbH'/Desktop";
      ipython="ipython3";
    };
  };
  fonts.fontconfig.enable = true;

  programs.starship = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    history.extended = true;
    dotDir = ".config/zsh";
    initExtraFirst = ''
      export GPG_TTY=$(tty)
      
      eval "$(ssh-agent -s)"
      ssh-add ~/.ssh/work

      eval "$(direnv hook zsh)"
      eval "$(direnv stdlib)"
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      export PATH="$PATH:/home/piankris/.local/share/coursier/bin"
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
  programs.pyenv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
  programs.neovim = {
    enable = true;
    extraConfig = ''
      set number relativenumber
    '';
  };
  programs.home-manager.enable = true;
  
  programs.git = {
  enable = true;
  userName = "Kristina Pianykh";
  userEmail = "kristinavrnrus@gmail.com";
  signing = {
    key = "C66C7DFC66E169F1";
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
    condition = "gitdir:${homeDirectory}/Work/";
    contents = {
      user = {
        name = "Kristina Pianykh";
        email = "kristina.pianykh@diconium.com";
        signingKey = "3A09BEC8E7DCA833";
      };
      commit = {
        gpgSign = true;
      };
    };
  }
  ];
  };
}
