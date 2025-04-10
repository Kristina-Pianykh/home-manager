{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file."date_parser.py" = {
    text = ''
      import os
      from datetime import datetime
      import argparse


      def get_last_modified_date(file_path):
          try:
              # Get the last modified timestamp
              timestamp = os.path.getmtime(file_path)
              # Convert timestamp to a human-readable date and time
              return datetime.fromtimestamp(timestamp).strftime("%Y-%m-%d %H:%M:%S")
          except FileNotFoundError:
              return f"Error: The file {file_path} does not exist."


      def get_last_modified_timestamp(file_path):
          try:
              # Get the last modified timestamp (epoch)
              return int(os.path.getmtime(file_path))
          except FileNotFoundError:
              return f"Error: The file {file_path} does not exist."


      if __name__ == "__main__":
          # Set up argument parser
          parser = argparse.ArgumentParser(
              description="Get the last modified date or timestamp of a file."
          )
          parser.add_argument("file", help="The absolute path to the file")
          parser.add_argument(
              "--date",
              action="store_true",
              help="Print the last modified date in human-readable format",
          )
          parser.add_argument(
              "--timestamp",
              action="store_true",
              help="Print the last modified timestamp (epoch)",
          )

          # Parse arguments
          args = parser.parse_args()

          if args.date:
              # Print the human-readable date
              print(get_last_modified_date(args.file))
          elif args.timestamp:
              # Print the Unix timestamp (epoch)
              print(get_last_modified_timestamp(args.file))
          else:
              # If no argument is provided, show usage message
              print("Error: You must specify either --date or --timestamp")
    '';
  };
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
          local_epoch=$(python3 $HOME/date_parser.py $WATCHED_FILE --timestamp)
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
