{
  pkgs,
  config,
  ...
}: {
  programs.ghostty = {
    package =
      pkgs.writeScriptBin "null" "";
    enable = true;
    enableZshIntegration = true;
    # installVimSyntax = true;
    settings = {
      theme = "light:rose-pine-dawn,dark:rose-pine";
    };
  };
}
