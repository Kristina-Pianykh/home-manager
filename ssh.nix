{config, pkgs, ...}: {
  programs.ssh = {
    enable = true;
    addKeysToAgent = "no";
    forwardAgent = false;
    matchBlocks = {
      work = {
        host = "work";
        hostname = "github.com";
        identityFile = "${config.home.homeDirectory}/.ssh/work";
        extraOptions = {
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
        };
      };
      priv = {
        host = "priv";
        hostname = "github.com";
        identityFile = "${config.home.homeDirectory}/.ssh/private";
        extraOptions = {
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
        };
      };
      bitbucket = {
        host = "workbitbucket";
        hostname = "bitbucket.org";
        identityFile = "${config.home.homeDirectory}/.ssh/work";
        extraOptions = {
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
        };
      };
    };
  };
}
