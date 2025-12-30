#!/bin/bash
# # shellcheck disable=SC2312,SC2310
set -eufo pipefail
splitter=0
forrigelinje=""
while IFS= read -r linje; do
  if [[ -z ${forrigelinje} ]]; then
    forrigelinje="${linje//S/|}"
    # echo "${forrigelinje}"
  else
    for ((t = 0; t < ${#linje}; t++)); do
      if [[ ${forrigelinje:t:1} == "|" ]]; then
        case "${linje:t:1}" in
          ".")
            linje="${linje:0:t}|${linje:$((t + 1)):$((${#linje} - t - 1))}"
            ;;
          "^")
            splitter=$((splitter + 1))
            linje="${linje:0:$((t - 1))}|^|${linje:$((t + 2)):$((${#linje} - t - 2))}"
            ;;
          *) ;;
        esac
      fi
    done
    forrigelinje="${linje}"
  fi
  # echo "${linje}"
done <input_aoc7.txt
echo "${splitter}"
