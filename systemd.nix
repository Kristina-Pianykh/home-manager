{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file."watcher.sh" = {
    text = ''
      #!/usr/bin/env sh

      WATCHED_FILE=$HOME/Documents/Database.kdbx
      REMOTE=drive:KeeShit/ # TODO

      echo "Watching $WATCHED_FILE for changes..."

      while true; do
          inotifywait -e close_write "$WATCHED_FILE"
          echo "Detected change, syncing..."
          rclone copy "$WATCHED_FILE" "$REMOTE"
      done
    '';
    executable = true;
  };

  systemd.user = {
    enable = true;
    systemctlPath = "/usr/bin/systemctl";
    services.rclone_keepass_gdrive_sync_hm = {
      Unit = {
        Description = "Syncs KeePass database to Google Drive on write";
      };

      Service = {
        Type = "simple";
        Restart = "always";
        ExecStart = "%h/watcher.sh";
        StandardOutput = "journal";
        Environment = [
          "PATH=${lib.makeBinPath [pkgs.bash pkgs.rclone pkgs.coreutils pkgs.inotify-tools]}"
        ];
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
