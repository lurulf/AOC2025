#!/bin/bash
# shellcheck disable=SC2312
set -eufo pipefail
inndatafil="./input_aoc8.txt"

mapfile -t punkter <"${inndatafil}"

declare -a kretsmedlem
declare -a kretsmedlemmer
makskretser=-1
antallkretser=0
punkterikretser=0
allepunkter="${#punkter[@]}"

for ((t = 0; t < ${#punkter[@]}; t++)); do
  kretsmedlem[t]=-1
  kretsmedlemmer[t]=""
done

teller=0
while IFS= read -r avstand; do
  IFS=, read -r -a data <<<"${avstand}"
  kd1="${kretsmedlem[data[1]]}"
  kd2="${kretsmedlem[data[2]]}"
  if ((kd1 < 0 && kd2 < 0)); then
    makskretser=$((makskretser + 1))
    kretsmedlem[data[1]]="${makskretser}"
    kretsmedlem[data[2]]="${makskretser}"
    kretsmedlemmer[makskretser]="${data[1]},${data[2]}"
    antallkretser=$((antallkretser + 1))
    punkterikretser=$((punkterikretser + 2))
  elif ((kd1 < 0)); then
    kretsmedlem[data[1]]="${kd2}"
    kretsmedlemmer[kd2]+=",${data[1]}"
    punkterikretser=$((punkterikretser + 1))
  elif ((kretsmedlem[data[2]] < 0)); then
    kretsmedlem[data[2]]="${kd1}"
    kretsmedlemmer[kd1]+=",${data[2]}"
    punkterikretser=$((punkterikretser + 1))
  else
    if ((kd1 != kd2)); then
      IFS=, read -r -a medlemmer <<<"${kretsmedlemmer[kd2]}"
      for ((t = 0; t < ${#medlemmer[@]}; t++)); do
        kretsmedlem[medlemmer[t]]="${kd1}"
      done
      kretsmedlemmer[kd1]+=",${kretsmedlemmer[kd2]}"
      kretsmedlemmer[kd2]=""
      antallkretser=$((antallkretser - 1))
    fi
  fi
  printf "%6s %4s %4s\n" "${teller}" "${antallkretser}" "${punkterikretser}"
  if ((antallkretser == 1 && punkterikretser == allepunkter)); then
    break
  fi
  teller=$((teller + 1))
done < <(
  {
    for ((i1 = 0; i1 < ${#punkter[@]} - 1; i1++)); do
      IFS=, read -r -a p1 <<<"${punkter[i1]}"
      for ((i2 = i1 + 1; i2 < ${#punkter[@]}; i2++)); do
        IFS=, read -r -a p2 <<<"${punkter[i2]}"
        x=$((p1[0] - p2[0]))
        y=$((p1[1] - p2[1]))
        z=$((p1[2] - p2[2]))
        echo "$((x * x + y * y + z * z)),${i1},${i2}"
      done
    done
  } | sort -t, -k1,1n
)

echo "${avstand}"
IFS=, read -r -a data <<<"${avstand}"
echo "${punkter[data[1]]}"
echo "${punkter[data[2]]}"
echo "$(($(cut -d, -f1 <<<"${punkter[data[1]]}") * $(cut -d, -f1 <<<"${punkter[data[2]]}")))"
