{
  config,
  pkgs,
  sshWorkHostAlias,
  ...
}: {
  programs.ssh = {
    enable = true;
    # addKeysToAgent = "no"; # available in unstable for now
    forwardAgent = false;
    matchBlocks = {
      "${sshWorkHostAlias}" = {
        host = sshWorkHostAlias;
        hostname = "github.com";
        identitiesOnly = true;
        identityFile = "${config.home.homeDirectory}/.ssh/${sshWorkHostAlias}";
        extraOptions = {
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
        };
      };
    };
  };
}
