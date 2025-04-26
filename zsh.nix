{
  config,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = false; # unstable
    # enableAutosuggestions = false;
    syntaxHighlighting.enable = true;
    enableCompletion = false;
    history.extended = true;
    dotDir = ".config/zsh";

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
        export GNUPGHOME="~/.gnupg"
        export GPG_TTY=$(tty)
      '')
      (lib.mkAfter ''
        # hack for copying to system clipboard https://github.com/jeffreytse/zsh-vi-mode/issues/19#issuecomment-1145784731
        # use another copy util for macos
        zvm_vi_yank () {
          zvm_yank
          echo -en ''${CUTBUFFER} |  wl-copy -n
          zvm_exit_visual_mode ''${1:-true}
        }
      '')
    ];

    prezto = {
      enable = true;
      pmodules = [
        # "syntax-highlighting"
        "history-substring-search"
        "autosuggestions"
        "environment"
        "terminal"
        "history"
        "directory"
        "spectrum"
        "utility"
        "completion"
      ];
    };
    zplug = {
      enable = true;
      plugins = [
        {
          name = "jeffreytse/zsh-vi-mode";
        }
      ];
      zplugHome = "${config.xdg.configHome}/zplug";
    };
  };
}
