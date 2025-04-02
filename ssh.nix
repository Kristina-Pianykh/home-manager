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
    };
  };
}
