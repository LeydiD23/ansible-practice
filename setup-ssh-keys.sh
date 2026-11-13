#!/usr/bin/env bash
set -euo pipefail

KEY="$HOME/.ssh/id_ed25519"

if [ ! -f "$KEY" ]; then
  mkdir -p "$HOME/.ssh"
  ssh-keygen -t ed25519 -N "" -f "$KEY"
fi

PUB="$(cat "$KEY.pub")"

for i in 1 2 3 4 5; do
  docker exec "ubuntu$i" bash -c "
    mkdir -p /home/ansible/.ssh &&
    printf '%s\n' '$PUB' > /home/ansible/.ssh/authorized_keys &&
    chown -R ansible:ansible /home/ansible/.ssh &&
    chmod 700 /home/ansible/.ssh &&
    chmod 600 /home/ansible/.ssh/authorized_keys
  "
  echo "Clave instalada en ubuntu$i"
done
