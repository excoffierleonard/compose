#!/bin/bash

# Define variables
COMPOSE_DIR="$(dirname "$(realpath "$0")")"
BACKUP_DIR="$COMPOSE_DIR/docker-backups"
DATE=$(date +'%Y-%m-%d_%H-%M-%S')

# Check if user supplied DOCKERDIRECTORYNAME
if [ -z "$1" ]; then
  echo "Usage: $0 <DOCKERDIRECTORYNAME>"
  exit 1
fi

DOCKER_DIR_NAME=$1
TARGET_DIR="$COMPOSE_DIR/$DOCKER_DIR_NAME"
BACKUP_FILE="$BACKUP_DIR/${DOCKER_DIR_NAME}_backup_$DATE.tar.gz"

# Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "Directory $TARGET_DIR does not exist!"
  exit 1
fi

# Create the backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "Backing up compose directory and volumes for $DOCKER_DIR_NAME..."

# Identify the volumes
VOLUMES=$(docker compose -f "$TARGET_DIR"/compose.yaml config --volumes)

if [ -z "$VOLUMES" ]; then
  echo "No volumes found or failed to retrieve volumes from Docker Compose."
  exit 0
fi

# Convert multiline result into an array
VOLUME_ARRAY=($(echo "$VOLUMES"))

# Initialize a temp directory for copying the volume contents
TEMP_VOL_DIR=$(mktemp -d)
TEMP_CONTAINER_NAME="temp_backup_container"

# Iterate over each volume
for VOLUME in "${VOLUME_ARRAY[@]}"; do
  # Mount the volume to a temporary Alpine container
  docker run --rm --name "$TEMP_CONTAINER_NAME" \
    -v "${VOLUME}:/mnt/vol" \
    -v "${TEMP_VOL_DIR}:/mnt/backup" \
    alpine sh -c "cp -r /mnt/vol /mnt/backup/$VOLUME"

  if [ $? -ne 0 ]; then
    echo "Warning: Failed to copy data from volume $VOLUME"
  else
    echo "Successfully backed up volume $VOLUME"
  fi
done

# Stop the Docker services to ensure file consistency (optional, uncomment if desired)
# docker compose -f "$TARGET_DIR"/compose.yaml down

# Create the backup file by compressing the entire compose directory and the temporary volume directory
tar czf "$BACKUP_FILE" -C "$TARGET_DIR" . -C "$TEMP_VOL_DIR" .

# Clean up the temporary directory
rm -rf "$TEMP_VOL_DIR"

# Start the Docker services back up (optional, uncomment if desired)
# docker compose -f "$TARGET_DIR"/compose.yaml up -d

echo "Backup completed: $BACKUP_FILE"

exit 0
