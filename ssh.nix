{
  config,
  pkgs,
  ...
}: {
  programs.ssh = {
    enable = true;
    # addKeysToAgent = "no"; # available in unstable for now
    forwardAgent = false;
    matchBlocks = {
      work = {
        host = "work";
        hostname = "github.com";
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/work";
        extraOptions = {
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
        };
      };
      priv = {
        host = "priv";
        hostname = "github.com";
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/private";
        extraOptions = {
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
        };
      };
      bitbucket = {
        host = "workbitbucket";
        hostname = "bitbucket.org";
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/work";
        extraOptions = {
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
        };
      };
    };
  };
}
