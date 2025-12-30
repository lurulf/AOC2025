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
  if ((fersk[0] > ferskslutt + 1)); then
    ingrediensteller=$((ingrediensteller + 1))
    ferskeingredienser[ingrediensteller]="${data}"
    ferskstart="${fersk[0]}"
    ferskslutt="${fersk[1]}"
  elif ((fersk[1] <= ferskslutt)); then
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

ferskteller=0
fersksjekkteller=-1
ferskstart=-10
ferskslutt=-10
while IFS= read -r ingrediensnummer; do
  # echo "Må finne nye grenser: ingnr:${ingrediensnummer} start:${ferskstart} slutt: ${ferskslutt}"
  while ((ingrediensnummer > ferskslutt && fersksjekkteller < ingrediensteller)); do
    fersksjekkteller=$((fersksjekkteller + 1))
    IFS=- read -r -a fersk <<<"${ferskeingredienser[fersksjekkteller]}"
    ferskstart="${fersk[0]}"
    ferskslutt="${fersk[1]}"
    # echo "ny grense: ingnr:${ingrediensnummer} start:${ferskstart} slutt: ${ferskslutt}"
  done
  if ((ingrediensnummer >= ferskstart && ingrediensnummer <= ferskslutt && fersksjekkteller <= ingrediensteller)); then
    # echo "fersk ingrediens:${ingrediensnummer} start:${ferskstart} slutt: ${ferskslutt} fst:${fersksjekkteller} ingt:${ingrediensteller}"
    ferskteller=$((ferskteller + 1))
  else
    # echo "dårlig ingrediens:${ingrediensnummer} > største ferske verdi = ${ferskslutt}"
    continue
  fi
done < <(grep -v -- '-' "${inndatafil}" | grep -vE '^[[:space:]]*$' | sort -n)

echo "${ferskteller}"
