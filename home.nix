{
  config,
  pkgs,
  lib,
  ...
}: let
  username = "krispian";
  homeDirectory = "/Users/${username}";
  nullPackage = name: pkgs.writeShellScriptBin name "";
in {
  imports = [
    ./zsh.nix
    ./kitty.nix
    ./nvim.nix
    ./git.nix
    ./ssh.nix
    ./dotfiles/ideavimrc.nix
  ];

  nixpkgs.config.allowUnfree = true;
  home = {
    inherit username homeDirectory;
    stateVersion = "23.11";
    packages = with pkgs; [
      lsd
      bat
      #nerdfonts
      #joypixels
      awscli
      rustup
      # parquet-tools # lib deps need update on their side
      ripgrep
      gnupg
      poetry
      tree
      jdk
      libreoffice-bin
      fzf
      jq
      docker
      docker-compose
      azure-cli
      tflint
      terraform
      go
      maven
      fd # extends capabilities of rg
      nodePackages.pyright
      luajitPackages.lua-lsp
      prettierd
      stylua
      ruff
      alejandra
      nodejs_21
      terraform-ls
      sops
      python311Packages.ipython
      openssl
    ];

    sessionVariables = {
      EDITOR = "nvim";
      JAVA_HOME = pkgs.jdk;
    };

    shellAliases = {
      nvim = "NVIM_APPNAME=neovim-config ${pkgs.neovim}/bin/nvim";
      ls = "lsd -la";
      lsd = "lsd -la";
      rm = "rm -f";
      home = "$EDITOR ~/.config/home-manager/home.nix";
      ipython = "ipython3";
    };
  };

  #fonts.fontconfig.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      package.disabled = true;
      gcloud.detect_env_vars = ["CLOUDSDK_CONFIG" "CLOUDSDK_ACTIVE_CONFIG_NAME" "CLOUDSDK_PROFILE"];
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.pyenv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.home-manager.enable = true;

  xdg.enable = true;
}
