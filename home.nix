{
  config,
  pkgs,
  lib,
  inputs,
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
    ./ripgrep.nix
  ];

  nixpkgs.overlays = [
    (final: _: {
      unstable = import inputs.nixpkgs-unstable {
        system = final.system;
        config.allowUnfree = true;
      };
    })
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
      rye
      unstable.uv
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
      lua-language-server
      java-language-server
      ccls
      python311Packages.compiledb
      bison
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
      # python311Packages.databricks-cli # points to deprecated repo
      openssl
      infracost
      openvpn
      netcat-gnu
      (bats.withLibraries (p: [p.bats-assert]))
      dbt
      # python311Packages.dbt-core
      # python311Packages.dbt-redshift
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
      nvim = "NVIM_APPNAME=neovim-config ${pkgs.neovim}/bin/nvim";
      ls = "lsd -la";
      lsd = "lsd -la";
      rm = "rm -f";
      s = "cd /Users/krispian/Uni/bachelorarbeit/sigmod24-flink/mama-module";
      m = "cd /Users/krispian/Uni/bachelorarbeit/sigmod24-flink/mama-module/monitoring";
      d = "cd /Users/krispian/Uni/bachelorarbeit/sigmod24-flink/deploying";
      f = "cd /Users/krispian/Uni/bachelorarbeit/topologies/SEQ_ABC";
      t = "cd /Users/krispian/Uni/bachelorarbeit/project/test_field";
      p = "cd /Users/krispian/Uni/bachelorarbeit/project/multisink-adaptive";
      home = "$EDITOR ~/.config/home-manager/home.nix";
      ipython = "ipython3";
      gl = "${./git_log_alias.sh}";
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
