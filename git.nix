{config, pkgs, ...}: {

  # options = {
  #   git = {
  #     homeDirectory = lib.mkOption {
  #       type = lib.types.str;
  #     };
  #     enable = lib.mkOption {
  #       type = lib.types.bool;
  #       default = true;
  #     };
  #   };
  # };
  #
  # cfg = config.module.git;
  # config = {
  #   homeDirectory = 
  # }

  programs.git = {
    enable = true;
    userName = "Kristina Pianykh";
    userEmail = "kristinavrnrus@gmail.com";
    signing = {
      key = "C66C7DFC66E169F1";
      gpgPath = "${pkgs.gnupg}/bin/gpg";
      signByDefault = true;
    };
    diff-so-fancy.enable = true;
    extraConfig = {
      init = {
          defaultBranch = "main";
      };
      core.editor = "nvim";
    };
    includes = [
      { 
        condition = "gitdir:${config.home.homeDirectory}/Work/";
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
