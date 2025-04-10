{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file."keepass_sync.sh" = {
    text = ''
      #!/usr/bin/env sh

      WATCHED_DIR=$HOME/Documents/KeePass
      WATCHED_FILE=$WATCHED_DIR/Database.kdbx
      REMOTE=drive:KeeShit/
      REMOTE_FILE=drive:KeeShit/Database.kdbx

      echo "Watching $WATCHED_FILE for changes..."

      while true; do
        local_sha=$(sha256sum "$WATCHED_FILE" | awk '{print $1}')
        remote_sha=$(rclone hashsum sha256 $REMOTE_FILE 2>/dev/null | awk '{print $1}')

        if [[ "$local_sha" != "$remote_sha" ]]; then
          echo "[$(date '+%Y-%m-%d %H:%M:%S')] Checksums differ"

          # Get timestamps
          if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Linux
            local_epoch=$(stat -c %Y "$WATCHED_FILE")
          elif [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            local_epoch=$(stat -f %m "$WATCHED_FILE")
          fi

          remote_date=$(rclone lsl "$REMOTE_FILE" 2>/dev/null | awk '{print $2, $3}')
          if date -d "$remote_date" +%s >/dev/null 2>&1; then
            remote_epoch=$(date -d "$remote_date" +%s)
          else
            remote_epoch=$(date -j -f "%Y-%m-%d %H:%M:%S" "$remote_date" +%s)
          fi

          echo "Remote modified: $(date -d @$remote_epoch '+%Y-%m-%d %H:%M:%S')"
          echo "Local modified : $(date -d @$local_epoch '+%Y-%m-%d %H:%M:%S')"

          if (( remote_epoch > local_epoch )); then
            echo "Downloading newer remote version..."
            rclone copyto "$REMOTE_FILE" "$WATCHED_FILE"
          else
            echo "Uploading newer local version..."
            rclone copy "$WATCHED_FILE" $REMOTE
          fi
        fi

        sleep 60
      done
    '';
    executable = true;
  };

  systemd.user = {
    enable = true;
    systemctlPath = "/usr/bin/systemctl";
    services.rclone_keepass_gdrive_sync = {
      Unit = {
        Description = "Syncs KeePass database to Google Drive on write";
      };

      Service = {
        Type = "simple";
        Restart = "always";
        ExecStart = "%h/keepass_sync.sh";
        StandardOutput = "journal";
        Environment = [
          "PATH=${lib.makeBinPath [pkgs.bash pkgs.rclone pkgs.coreutils pkgs.gawk]}"
        ];
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
