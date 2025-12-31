#!/bin/bash
# shellcheck disable=SC2312
set -eufo pipefail
inndatafil="./input_aoc9.txt-test"

mapfile -t punkter <"${inndatafil}"

{
  for ((i1 = 0; i1 < ${#punkter[@]} - 1; i1++)); do
    IFS=, read -r -a p1 <<<"${punkter[i1]}"
    for ((i2 = i1 + 1; i2 < ${#punkter[@]}; i2++)); do
      IFS=, read -r -a p2 <<<"${punkter[i2]}"
      if ((p1[0] != p2[0] && p1[1] != p2[1])); then
        xd="$((p1[0] - p2[0]))"
        yd="$((p1[1] - p2[1]))"
        echo "$(((${xd#-} + 1) * (${yd#-} + 1)))"
      fi
    done
  done
} | sort -n | tail -1
