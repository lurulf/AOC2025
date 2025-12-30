#!/bin/bash
# shellcheck disable=SC2312,SC2310
set -eufo pipefail

declare -a cephamatte
cephateller=-1
while IFS= read -r data; do
  cephateller=$((cephateller + 1))
  cephamatte[cephateller]="${data}"
done <"./input_aoc6.txt"

# printf "%s\n" "${cephamatte[@]}"
# echo "cephateller: ${cephateller}"

sum=0
indeks=$((${#cephamatte[0]} - 1))
while ((indeks >= 0)); do
  op=" "
  tallteller=0
  while [[ ${op} == " " ]]; do
    tall[tallteller]=""
    for ((t = 0; t < cephateller; t++)); do
      tegn="${cephamatte[t]:indeks:1}"
      if [[ ${tegn} != " " ]]; then
        tall[tallteller]+="${tegn}"
      fi
    done
    tallteller=$((tallteller + 1))
    op="${cephamatte[cephateller]:indeks:1}"
    indeks=$((indeks - 1))
    # echo "op: \"${op}\""
    # printf "%s\n" "${tall[@]}"
  done
  # echo "op: \"${op}\""
  # printf "%s\n" "${tall[@]}"
  case "${op}" in
    "+")
      for ((tt = 0; tt < tallteller; tt++)); do
        sum=$((sum + tall[tt]))
      done
      ;;
    "*")
      delsum=1
      for ((tt = 0; tt < tallteller; tt++)); do
        delsum=$((delsum * tall[tt]))
      done
      sum=$((sum + delsum))
      ;;
    *)
      echo "Feil op: \"${op}\""
      exit 1
      ;;
  esac
  indeks=$((indeks - 1))
done

echo "${sum}"
