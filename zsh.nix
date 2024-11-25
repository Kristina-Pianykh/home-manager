{config, ...}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = false; # unstable
    # enableAutosuggestions = false;
    syntaxHighlighting.enable = true;
    enableCompletion = false;
    history.extended = true;
    dotDir = ".config/zsh";

    initExtraFirst = ''
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
      export GNUPGHOME="~/.gnupg"
      export GPG_TTY=$(tty)

    '';

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
