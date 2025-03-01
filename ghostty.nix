{
  pkgs,
  config,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package =
      pkgs.writeScriptBin "null" "";
    enableZshIntegration = true;
    # installVimSyntax = true;
    settings = {
      theme = "dark:rose-pine";
    };
  };
}
