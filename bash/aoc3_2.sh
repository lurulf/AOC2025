#!/bin/bash
# shellcheck disable=SC2312
set -eufo pipefail

# antall batterier vi skal bruke i en batteribank
antallbatterier=12

# sum av batterier i alle banker
joltsum=0

while IFS= read -r batteribank; do
  # antall batterier i en batteribank
  batteribankstorrelse=${#batteribank}

  # echo "batteribank=${batteribank}"
  # echo "batteribankstorrelse=${batteribankstorrelse}"

  # startvalg av batterier
  batterier="${batteribank:0:antallbatterier}"
  # echo "start:     batterier=${batterier}"
  for ((bbstart = 1; bbstart <= batteribankstorrelse - antallbatterier; bbstart++)); do
    # echo "sammenlign:          ${batteribank:${bbstart}:${antallbatterier}}"
    for ((bbteller = 0; bbteller < antallbatterier; bbteller++)); do
      # echo "batterier[${bbteller}]=${batterier:${bbteller}:1}, batteribank[$((bbstart+bbteller))]=${batteribank:$((bbstart+bbteller)):1}"
      if ((${batterier:bbteller:1} < ${batteribank:$((bbstart + bbteller)):1})); then
        # echo "bbstart=${bbstart}"
        # echo "bbteller=${bbteller}"
        # echo "${batterier:0:${bbteller}} ${bbteller}"
        # echo "${batterier:$((bbteller+1)):$((antallbatterier-(bbteller+1)))} $((bbteller+1)) $((antallbatterier-(bbteller+1)))"
        # echo "${batteribank:$((bbstart+antallbatterier-1)):1} $((bbstart+antallbatterier-1))"
        batterier="${batterier:0:bbteller}${batterier:$((bbteller + 1)):$((antallbatterier - (bbteller + 1)))}${batteribank:$((bbstart + antallbatterier - 1)):1}"
        # echo "underveis: batterier=${batterier}"
        break
      fi
    done
  done
  # echo "${batterier}"
  joltsum=$((joltsum + batterier))
done <input_aoc3.txt
echo "${joltsum}"
