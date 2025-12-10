#!/bin/bash
# shellcheck disable=SC2312,SC2310
set -eufo pipefail

# lese inn fil
maksy=-1
while IFS= read -r data; do
  maksy=$((maksy + 1))
  kart[maksy]="${data}"
done <input_aoc4.txt
# done < input_aoc4.txt-test
maksx="$((${#kart[maksy]} - 1))"

# returnerer 1 hvis det er en rull på gyldig koordinat, ellers returnere 0
errull() {
  local x y
  x="$1"
  y="$2"
  if ((y < 0 || y > maksy || x < 0 || x > maksx)); then
    echo 0
    return
  fi
  if [[ ${kart[y]:x:1} == "@" ]]; then
    echo 1
  else
    echo 0
  fi
}

# teller ruller rundt gyldig koordinat
tellruller() {
  local x y
  x="$1"
  y="$2"
  if ((y < 0 || y > maksy || x < 0 || x > maksx)); then
    echo "ugyldige koordinater: ${x} ${y}"
    exit 1
  fi
  echo "$((\
  $(errull $((x - 1)) "${y}") + \
  $(errull $((x - 1)) $((y - 1))) + \
  $(errull "${x}" $((y - 1))) + \
  $(errull $((x + 1)) $((y - 1))) + \
  $(errull $((x + 1)) "${y}") + \
  $(errull $((x + 1)) $((y + 1))) + \
  $(errull "${x}" $((y + 1))) + \
  $(errull $((x - 1)) $((y + 1)))))"
}

plukkederuller=0

for ((y = 0; y <= maksy; y++)); do
  for ((x = 0; x <= maksx; x++)); do
    if (($(errull "${x}" "${y}") == 1)); then
      if (($(tellruller "${x}" "${y}") < 4)); then
        plukkederuller=$((plukkederuller + 1))
      fi
    fi
  done
done

echo "${plukkederuller}"
