#!/bin/bash
# Ensure danrobi is in the audio and input groups via /etc/group.
# The account is created on the host, so this runs at boot rather than in the image build.
ensure_member() {
  local name="$1" gid="$2" user=danrobi line
  if ! grep -q "^${name}:" /etc/group; then
    echo "${name}:x:${gid}:${user}" >> /etc/group
    return
  fi
  if grep -q "^${name}:.*${user}" /etc/group; then
    return
  fi
  line=$(grep "^${name}:" /etc/group)
  case "$line" in
    *: ) sed -i "/^${name}:/s/$/${user}/" /etc/group ;;
    * )  sed -i "/^${name}:/s/$/,${user}/" /etc/group ;;
  esac
}

# GIDs match /usr/lib/sysusers.d/setup.conf
ensure_member audio 63
ensure_member input 104
