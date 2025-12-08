#!/bin/bash
# shellcheck disable=SC2312,SC2310
set -eufo pipefail

# lese inn fil
maksy=-1
while IFS= read -r data; do
  maksy=$((maksy+1))
  kart[maksy]="${data}"
done < input_aoc4.txt
# done < input_aoc4.txt-test
maksx="$((${#kart[maksy]}-1))"

plukkederuller=0

# returnerer 1 hvis det er en rull på gyldig koordinat, ellers returnere 0
errull() {
  local x y
  x="$1"
  y="$2"
  if (( y < 0 || y > maksy || x < 0 || x > maksx)); then
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
  if (( y < 0 || y > maksy || x < 0 || x > maksx)); then
    echo 0
    return
  fi
  echo "$((
    $(errull $((x-1)) "${y}") +
    $(errull $((x-1)) $((y-1))) +
    $(errull "${x}" $((y-1))) +
    $(errull $((x+1)) $((y-1))) +
    $(errull $((x+1)) "${y}") +
    $(errull $((x+1)) $((y+1))) +
    $(errull "${x}" $((y+1))) +
    $(errull $((x-1)) $((y+1)))
  ))"
}

# plukker (sletter) rull på gyldig koordinat hvis det er færre enn 4 ruller rundt
plukkrull() {
  local x y
  x="$1"
  y="$2"
  if (( y < 0 || y > maksy || x < 0 || x > maksx)); then
    return
  fi
  if (($(errull "${x}" "${y}") == 1)); then
    if (($(tellruller "${x}" "${y}") < 4)); then
      # if ((x==0)); then
        # kart[y]="x${kart[y]:1:${maksx}}"
      # elif ((x==maksx)); then
        # kart[y]="${kart[y]:0:${maksx}}x"
      # else
        # kart[y]="${kart[y]:0:${x}}x${kart[y]:$((x+1)):$((maksx-x))}"
      # fi
      plukkederuller=$((plukkederuller+1))
    fi
  fi
}

for ((y=0;y<=maksy;y++)); do
  for ((x=0;x<=maksx;x++)); do
    plukkrull "${x}" "${y}"
  done
done

# printf "%s\n" "${kart[@]}"

echo "${plukkederuller}"
