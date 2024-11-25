{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  username = "krispian";
  homeDirectory = "/home/${username}";
  nullPackage = name: pkgs.writeShellScriptBin name "";
in {
  imports = [
    ./zsh.nix
    ./kitty.nix
    ./git.nix
    ./ssh.nix
    ./dotfiles/ideavimrc.nix
    ./ripgrep.nix
  ];

  nixpkgs.overlays = [
    (final: _: {
      unstable = import inputs.nixpkgs-unstable {
        system = final.system;
        config.allowUnfree = true;
      };
    })
    inputs.nixgl.overlay
  ];
  nixpkgs.config.allowUnfree = true;
  home = {
    inherit username homeDirectory;
    stateVersion = "23.11";
    packages = with pkgs; [
      lsd
      bat
      #joypixels
      rustup
      ripgrep
      poetry
      unstable.uv
      tree
      jdk
      fzf
      jq
      docker
      docker-compose
      tflint
      terraform
      go
      maven
      fd # extends capabilities of rg
      nodePackages.pyright
      lua-language-server
      lua54Packages.luacheck
      java-language-server
      jdt-language-server
      vimPlugins.nvim-jdtls
      ccls
      python311Packages.compiledb
      google-java-format
      prettierd
      stylua
      astyle
      ruff
      alejandra
      nodejs_22
      terraform-ls
      sops
      python311Packages.ipython
      openssl
      netcat-gnu
      python311Packages.ipython
      (bats.withLibraries (p: [p.bats-assert]))
      parallel
      unstable.hugo

      # (writeShellApplication {
      #   name = "show-nixos-org";
      #
      #   runtimeInputs = [curl w3m];
      #
      #   text = ''
      #     curl -s 'https://nixos.org' | w3m -dump -T text/html
      #   '';
      # })
    ];

    sessionVariables = {
      EDITOR = "nvim";
      JAVA_HOME = pkgs.jdk;
    };

    shellAliases = {
      # nvim = "NVIM_APPNAME=neovim-config ${pkgs.neovim}/bin/nvim";
      ls = "lsd -la";
      lsd = "lsd -la";
      rm = "rm -f";
      home = "cd ~/.config/home-manager && $EDITOR .";
      ipython = "ipython3";
      gl = "${./git_log_alias.sh}";
      gst = "git status";
    };
  };

  #fonts.fontconfig.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      package.disabled = true;
      # gcloud.detect_env_vars = ["CLOUDSDK_CONFIG" "CLOUDSDK_ACTIVE_CONFIG_NAME" "CLOUDSDK_PROFILE"];
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
