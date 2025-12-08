#!/bin/bash
# shellcheck disable=SC2312,SC2310
set -eufo pipefail

inndatafil="./input_aoc5.txt"
ingrediensteller=-1
ferskstart=-10
ferskslutt=-10

# data kommer sortert inn etter ferskstart
while IFS= read -r data; do
  IFS=- read -r -a fersk <<<"${data}"
  # echo "grense ${fersk[0]} til ${fersk[1]}"
  if ((fersk[0]>ferskslutt+1)); then
    ingrediensteller=$((ingrediensteller+1))
    ferskeingredienser[ingrediensteller]="${data}"
    ferskstart="${fersk[0]}"
    ferskslutt="${fersk[1]}"
  elif ((fersk[1]<=ferskslutt)); then
    # echo "${fersk[1]}<=$((ferskslutt))"
    continue
  else
    # echo "Ny ferskslutt: ${ingredienser[ingrediensteller]} ==> ${fersk[1]}"
    ferskslutt="${fersk[1]}"
    ferskeingredienser[ingrediensteller]="${ferskstart}-${ferskslutt}"
  fi
done < <(grep -- '-' "${inndatafil}" | sort -n)

# echo "ingrediensteller=${ingrediensteller}"
# printf "%s\n" "${ferskeingredienser[@]}"

ingredienser=0
for ((teller=0;teller<=ingrediensteller;teller++)); do
  IFS=- read -r -a fersk <<<"${ferskeingredienser[teller]}"
  echo "${teller}:${ferskeingredienser[teller]}"
  ingredienser=$((ingredienser+fersk[1]-fersk[0]+1))
done
echo "${ingredienser}"
