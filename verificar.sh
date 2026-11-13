#!/usr/bin/env bash
set -euo pipefail

for i in 1 2 3 4 5; do
  c="ubuntu$i"
  echo "=== $c ==="
  docker exec "$c" sh -c "id itla"
  docker exec "$c" sh -c "ls -l /home/itla/app/hola.txt"
  docker exec "$c" sh -c "/usr/games/cowsay -t 'Hola ITLA'"
  docker exec "$c" sh -c "htop --version"
done
