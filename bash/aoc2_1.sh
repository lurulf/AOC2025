#!/bin/bash
# shellcheck disable=SC2312
set -eufo pipefail

sum=0

while IFS= read -r data; do
  fra="${data%-*}"
  til="${data#*-}"
  for ((tall=fra;tall<=til;tall++)); do
    lengde=${#tall}
    if ((lengde % 2 == 0)); then
      halv=$((lengde/2))
      start="${tall:0:${halv}}"
      slutt="${tall:${halv}}"
      if [[ ${start} == "${slutt}" ]]; then
        # echo "${fra} ${til} ${tall} ${lengde} ${start} ${slutt}"
        sum=$((sum+tall))
      fi
    fi
  done
done < <(perl -pe 's|,|\n|g;' < input_aoc2.txt | sort -t- -k1,1n)
echo "${sum}"
