#!/bin/bash
# shellcheck disable=SC2312
set -eufo pipefail

mapfile -t manifold <input_aoc7.txt
startx=0
linje="${manifold[0]}"
declare -a straaler
declare -a forrigestraaler
declare -a tomstraaler
for ((t = 0; t < ${#linje}; t++)); do
  if [[ ${linje:t:1} == "S" ]]; then
    startx="${t}"
  fi
  straaler[t]=0
  tomstraaler[t]=0
done

straaler[startx]=1

for ((l = 1; l < ${#manifold}; l++)); do
  linje="${manifold[l]}"
  forrigestraaler=("${straaler[@]}")
  straaler=("${tomstraaler[@]}")
  for ((t = 0; t < ${#linje}; t++)); do
    case "${linje:t:1}" in
      ".")
        straaler[t]="$((straaler[t] + forrigestraaler[t]))"
        ;;
      "^")
        straaler[t - 1]=$((straaler[t - 1] + forrigestraaler[t]))
        straaler[t + 1]=$((straaler[t + 1] + forrigestraaler[t]))
        ;;
      *) ;;
    esac
  done
done

sum=0
for ((t = 0; t < ${#linje}; t++)); do
  sum=$((sum + straaler[t]))
done

echo "${sum}"
