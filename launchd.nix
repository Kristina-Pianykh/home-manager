{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file."watcher.sh" = {
    text = ''
      #!/usr/bin/env sh

      WATCHED_DIR=$HOME/Documents/KeePass
      WATCHED_FILE=$WATCHED_DIR/Database.kdbx
      REMOTE=drive:KeeShit/ # TODO

      echo "Watching $WATCHED_FILE for changes..."

      fswatch --event Updated --event MovedTo "$WATCHED_DIR" | while read; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Change detected, syncing..."
        rclone copy "$WATCHED_FILE" "$REMOTE"
      done
    '';
    executable = true;
  };

  launchd = {
    enable = true;
    agents."dev.kristina.watcher.plist" = {
      enable = true;
      config = {
        Program = "${config.home.homeDirectory}/watcher.sh";
        Label = "dev.kristina.watcher.plist";
        RunAtLoad = true;
        EnvironmentVariables = {
          PATH = "${lib.makeBinPath [pkgs.bash pkgs.rclone pkgs.coreutils pkgs.fswatch]}";
        };
        StandardOutPath = "/tmp/watcher.out.log";
        StandardErrorPath = "/tmp/watcher.err.log";
        KeepAlive = true;
      };
    };
  };
}
