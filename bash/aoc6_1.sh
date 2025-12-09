#!/bin/bash
# shellcheck disable=SC2312,SC2310
set -efo pipefail

inndatafil="./input_aoc6.txt"

declare -a cephamatte

while IFS= read -r data; do
  IFS=" " read -r -a liste <<<"${data}"
  for ((t=0;t<${#liste[@]};t++)); do
    cephamatte[t]="${liste[t]},${cephamatte[t]}"
  done
done < <(perl -pe 's| +| |g;s|^ ||;s| $||;' < "${inndatafil}")

sum=0
for ((t=0;t<${#cephamatte[@]};t++)); do
  # echo "${cephamatte[t]}"
  IFS="," read -r -a liste<<<"${cephamatte[t]}"
  case "${liste[0]}" in
    "+")
      sum=$((sum+liste[1]+liste[2]+liste[3]+liste[4]))
      ;;
    "*")
      sum=$((sum+liste[1]*liste[2]*liste[3]*liste[4]))
      ;;
    *)
      echo "Feil op: \"${liste[0]}\""
      exit 1
    ;;
  esac
done

echo "${sum}"
