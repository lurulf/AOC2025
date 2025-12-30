#!/bin/bash
# shellcheck disable=SC2312
set -eufo pipefail

mapfile -t manifold <input_aoc7.txt
startx=0
linje="${manifold[0]}"
for ((t = 0; t < ${#linje}; t++)); do
  if [[ ${linje:t:1} == "S" ]]; then
    startx="${t}"
  fi
done

straale() {
  local x y
  if (($# < 2)); then
    echo "Straale kalt med for få parametre: $#"
    exit 1
  fi
  x="$1"
  y="$2"
  while ((y < ${#manifold})); do
    if [[ ${manifold[y]:x:1} == "^" ]]; then
      echo "$(($(straale "$((x - 1))" "${y}") + $(straale "$((x + 1))" "${y}")))"
      break
    else
      y=$((y + 1))
    fi
  done
  if ((y == ${#manifold})); then
    echo "1"
  fi
}

straale "${startx}" 0
