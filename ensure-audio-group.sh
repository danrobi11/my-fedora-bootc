#!/bin/bash
# Ensure the audio group exists and danrobi is in it
getent group audio >/dev/null || groupadd -r audio
if id danrobi &>/dev/null; then
  usermod -aG audio danrobi
fi
