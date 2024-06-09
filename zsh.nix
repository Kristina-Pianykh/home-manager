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
      export GPG_TTY=$(tty)

      if [ -z "$SSH_AUTH_SOCK" ] && [ -z "$SSH_AGENT_PID" ]; then
        # If no SSH Agent is running, start one and load keys from Apple keychain
        eval "$(ssh-agent -s)"
        ssh-add --apple-load-keychain
      else
        if [ -z "$(ssh-add -l | grep SHA256)" ]; then
          # If agent is running but has no keys, load keys from Apple keychain
          ssh-add --apple-load-keychain
        fi
      fi

      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
    '';

    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
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
