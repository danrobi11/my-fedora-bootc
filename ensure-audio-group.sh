#!/bin/bash
# Ensure danrobi is in the audio group via /etc/group override
if ! grep -q '^audio:' /etc/group; then
  echo "audio:x:63:danrobi" >> /etc/group
elif ! grep -q '^audio:.*danrobi' /etc/group; then
  sed -i '/^audio:/s/$/,danrobi/' /etc/group
fi
