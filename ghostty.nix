{
  pkgs,
  config,
  ...
}: {
  programs.ghostty = {
    package = pkgs.stable.ghostty;
    enable = false;
    enableZshIntegration = true;
    # installVimSyntax = true;
    settings = {
      theme = "dark:rose-pine";
    };
  };
}
