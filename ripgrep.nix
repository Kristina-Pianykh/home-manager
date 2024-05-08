{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.ripgrep = {
    enable = true;
    package = pkgs.ripgrep;
    arguments = [
      "--no-ignore"
      "--hidden"
      "-g"
      "!**/.git/**"
      "-g"
      "!**/.venv"
      "-g"
      "!**/dist"
      "-g"
      "!**/build"
      "-g"
      "!**/target"
      "-g"
      "!**/*cache*"
      "-g"
      "!**/__pycache__"
      "-g"
      "!**/*.pyc"
      "--unrestricted"
      "--smart-case"
    ];
  };
}
