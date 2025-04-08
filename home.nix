{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  username = "kristina.pianykh@goflink.com";
  homeDirectory = "/Users/${username}";
  nullPackage = name: pkgs.writeShellScriptBin name "";
  gcloud = pkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin];
in {
  _module.args = {
    sshWorkHostAlias = "work";
  };

  imports = [
    ./zsh.nix
    ./launchd.nix
    ./kitty.nix
    ./ghostty.nix
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
      stable = import inputs.nixpkgs-stable {
        system = final.system;
        config.allowUnfree = true;
      };
    })
    inputs.nixgl.overlay
  ];
  nixpkgs.config.allowUnfree = true;
  news.display = "silent";
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
      gopls
      gotools
      maven
      fd # extends capabilities of rg
      pyright
      lua-language-server
      lua54Packages.luacheck
      java-language-server
      jdt-language-server
      vimPlugins.nvim-jdtls
      ccls
      # python311Packages.compiledb
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
      yazi
      rclone
      codecrafters-cli
      neovim
      podman
      # google-cloud-sdk
      gcloud
      kubectl
      vscode
      htop
      fswatch

      # flink related
      mask
      golangci-lint

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

  # xdg.enable = true;
  # xdg.configFile."easyeffects/output/advanced-auto-gain.json".source = let
  #   AAGainFile = pkgs.fetchurl {
  #     url = "https://github.com/JackHack96/EasyEffects-Presets/raw/834bc5007b976250190cd71937c8c22f182d2415/Advanced%20Auto%20Gain.json";
  #     hash = "sha256-AXzy04ORMeg39H7ojkRtuumT0HU0nKLkU1SKmmD9zzQ=";
  #   };
  #   AAGain = builtins.fromJSON (builtins.readFile AAGainFile);
  #   dolbyAtmos = pkgs.fetchurl {
  #     url = "https://github.com/JackHack96/EasyEffects-Presets/raw/5804c736be654de36c2fc052bff10260c1ac33c5/irs/Dolby%20ATMOS%20((128K%20MP3))%201.Default.irs";
  #     hash = "sha256-9Ft1HZLFTBiGRfh/wJiGZ9WstMtvdtX+u3lVY3JCVAM=";
  #   };
  #   extendedAAGain =
  #     AAGain
  #     // {
  #       output =
  #         AAGain.output
  #         // {
  #           "convolver" = {
  #             "autogain" = true;
  #             "bypass" = false;
  #             "input-gain" = 0.0;
  #             "ir-width" = 100;
  #             "kernel-path" = "${dolbyAtmos}";
  #             "output-gain" = 0.0;
  #           };
  #         }
  #         // {
  #           plugins_order = (lib.sublist 0 3 AAGain.output.plugins_order) ++ ["convolver"] ++ (lib.sublist 3 100 AAGain.output.plugins_order);
  #         };
  #     };
  #   source = pkgs.writeText "extendedAAGain" (builtins.toJSON extendedAAGain);
  # in "${source}";
}
