#!/usr/bin/env bash

# Script to download and install the Minecraft Java Server
# Usage: server-download.sh [version]
# If no version is provided, the latest version is used

if [ -n "$1" ] && [ "$1" != "latest" ]; then
  version=$1
else
  version=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r '.versions | first | .id')
fi

echo "Selected version $version..."
version_url=$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r '.versions | map(select(.id == "'$version'")) | .[0] | .url')

if [ -z "$version_url" ]; then
  echo "Version $version not found"
  exit 1
fi

downloads=$(curl -s "$version_url" | jq -r '.downloads.server')
server_url=$(echo "$downloads" | jq -r '.url')
expected_sha1=$(echo "$downloads" | jq -r '.sha1')

# Download the server jar
curl -s -o server.jar "$server_url"

# Verify the SHA-1 checksum
downloaded_sha1=$(sha1sum server.jar | awk '{ print $1 }')

if [ "$downloaded_sha1" == "$expected_sha1" ]; then
  echo "SHA-1 checksum verification passed."
else
  echo "SHA-1 checksum verification failed."
  exit 1
fi

# Unpacks the JAR and sets up eula.txt file
java -jar server.jar nogui
sed -i 's/false/true/' eula.txt
