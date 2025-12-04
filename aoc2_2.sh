#!/bin/bash
# shellcheck disable=SC2312
set -eufo pipefail

sum=0

while IFS= read -r data; do
  fra="${data%-*}"
  til="${data#*-}"
  for ((tall=fra;tall<=til;tall++)); do
    lengde=${#tall}
    # echo "================================="
    # echo "tall = ${tall}"
    # Må være 2 eller flere siffer for å få en feil
    if ((lengde > 1)); then
      feil=0
      for ((seksjonslengde=1;seksjonslengde<=lengde/2;seksjonslengde++)); do
        # echo "seksjonslengde = ${seksjonslengde}"
        if ((lengde % seksjonslengde == 0)); then
          seksjonsfeil=1
          seksjoner=$((lengde/seksjonslengde))
          sokestreng="${tall:0:seksjonslengde}"
          # echo "seksjoner = ${seksjoner}, sokestreng = ${sokestreng}"
          for ((seksjonsteller=1;seksjonsteller<seksjoner;seksjonsteller++)); do
            seksjonstart=$((seksjonsteller*seksjonslengde))
            # echo "seksjonsteller = ${seksjonsteller}, seksjon = ${tall:${seksjonstart}:${seksjonslengde}}"
            if [[ ${tall:${seksjonstart}:${seksjonslengde}} != "${sokestreng}" ]]; then
              seksjonsfeil=0
              # echo "indre seksjonsfeil=${seksjonsfeil} feil=${feil}"
              break
            fi
          done
        fi
        # echo "ytre seksjonsfeil=${seksjonsfeil} feil=${feil}"
        if ((seksjonsfeil == 1)); then
          # echo "ytre seksjonsfeil=${seksjonsfeil} feil=${feil}"
          feil=1
          break
        fi
      done
      if ((feil == 1)); then
        # echo "FEIL: ${fra} ${til} ${tall}"
        sum=$((sum+tall))
      fi
    fi
  done
done < <(perl -pe 's|,|\n|g;' < input_aoc2.txt | sort -t- -k1,1n)
echo "${sum}"
