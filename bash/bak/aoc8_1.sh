#!/bin/bash
# shellcheck disable=SC2312
set -eufo pipefail
inndatafil="./input_aoc8.txt"
antall=1000

mapfile -t punkter <"${inndatafil}"

declare -a kretsmedlem
declare -a kretsmedlemmer
makskretser=-1
for ((t = 0; t < ${#punkter[@]}; t++)); do
  kretsmedlem[t]=-1
  kretsmedlemmer[t]=""
done

# echo "${#punkter[@]}"

# printf "     "
# for ((t = 0; t < ${#kretsmedlem[@]}; t++)); do
# printf "%2s " "${t}"
# done
# echo ""

teller=0
while IFS= read -r avstand; do
  # echo "${avstand}"
  IFS=, read -r -a data <<<"${avstand}"
  # echo "${data[*]}"
  kd1="${kretsmedlem[data[1]]}"
  kd2="${kretsmedlem[data[2]]}"
  # printf "%4s %2s %2s %s\n" "${teller}" "${kd1}" "${kd2}" "${data[*]}"
  if ((kd1 < 0 && kd2 < 0)); then
    makskretser=$((makskretser + 1))
    # echo "ny krets: ${makskretser} = ${data[1]} og ${data[2]}"
    kretsmedlem[data[1]]="${makskretser}"
    kretsmedlem[data[2]]="${makskretser}"
    kretsmedlemmer[makskretser]="${data[1]},${data[2]}"
  elif ((kd1 < 0)); then
    # echo "kd1: ${data[1]} til krets ${kd2}"
    kretsmedlem[data[1]]="${kd2}"
    kretsmedlemmer[kd2]+=",${data[1]}"
  elif ((kretsmedlem[data[2]] < 0)); then
    # echo "kd2: ${data[2]} til krets ${kd1}"
    kretsmedlem[data[2]]="${kd1}"
    kretsmedlemmer[kd1]+=",${data[2]}"
  else
    if ((kd1 != kd2)); then
      # echo "koble sammen kretsene ${kd1} og ${kd2}"
      IFS=, read -r -a medlemmer <<<"${kretsmedlemmer[kd2]}"
      # echo "${kretsmedlemmer[kd2]}"
      # echo "${medlemmer[*]}"
      for ((t = 0; t < ${#medlemmer[@]}; t++)); do
        # echo "${t} ${medlemmer[t]}"
        kretsmedlem[medlemmer[t]]="${kd1}"
      done
      kretsmedlemmer[kd1]+=",${kretsmedlemmer[kd2]}"
      kretsmedlemmer[kd2]=""
    else
      # echo "${data[1]} og ${data[2]} er allerede i samme krets: ${kd1}"
      true
    fi
  fi
  # printf "%4s " "${teller}"
  # printf "%2s " "${kretsmedlem[@]}"
  # printf "%2s %2s %2s %2s %10s" "${kd1}" "${kd2}" "${data[1]}" "${data[2]}" "${data[0]}"
  # echo ""
  # echo "${kretsmedlemmer[*]}"
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
  } | sort -t, -k1,1n | sed -n "1,${antall}p"
)

# echo "===================================="
# printf "%s\n" "${kretsmedlem[@]}"
echo "===================================="
printf "%s\n" "${kretsmedlem[@]}" | sort | uniq -c | sort -rn
echo "===================================="
printf "%s\n" "${kretsmedlem[@]}" | sort | uniq -c | sort -rn | grep -v -- '-1' | sed -n "1,3p"
echo "===================================="

faktor=1
while read -r -a data; do
  faktor=$((faktor * data[0]))
done < <(printf "%s\n" "${kretsmedlem[@]}" | sort | uniq -c | sort -rn | grep -v -- '-1' | sed -n "1,3p")
echo "${faktor}"
