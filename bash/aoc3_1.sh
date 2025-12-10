#!/bin/bash
# shellcheck disable=SC2312
set -eufo pipefail

sum=0

while IFS= read -r batteribank; do
  lengde=${#batteribank}
  # finne de kraftigste batteriene i en batteribank
  # kb1 = kraftigste
  kb1=-1
  kb1posisjon=-1
  # kb2 = nest kraftigste
  kb2=-1
  kb2posisjon=-1
  # kb3 = kraftigste posisjonert etter kb1
  kb3=-1
  kb3posisjon=-1
  # kb4 = kraftigste posisjonert etter kb2
  kb4=-1
  kb4posisjon=-1
  for ((posisjon = 0; posisjon < lengde; posisjon++)); do
    batteri="${batteribank:posisjon:1}"
    if ((batteri > kb1)); then
      kb2="${kb1}"
      kb2posisjon="${kb1posisjon}"
      kb1="${batteri}"
      kb1posisjon="${posisjon}"
      if ((posisjon > kb2posisjon)); then
        kb4="${kb1}"
        kb4posisjon="${kb1posisjon}"
      else
        kb4="${kb3}"
        kb4posisjon="${kb3posisjon}"
      fi
      kb3=-1
      kb3posisjon=-1
    else
      if ((batteri > kb3)); then
        kb3="${batteri}"
        kb3posisjon="${posisjon}"
      fi
      if ((batteri > kb2)); then
        kb2="${batteri}"
        kb2posisjon="${posisjon}"
        kb4=-1
        kb4posisjon=-1
      elif ((batteri > kb4)); then
        kb4="${batteri}"
        kb4posisjon="${posisjon}"
      fi
    fi
  done
  if ((kb3 < 0)); then
    jolt="${kb2}${kb4}"
  else
    jolt="${kb1}${kb3}"
  fi
  echo "kb1=${kb1}, kb1posisjon=${kb1posisjon}  kb2=${kb2}, kb2posisjon=${kb2posisjon}  kb3=${kb3}, kb3posisjon=${kb3posisjon}  kb4=${kb4}, kb4posisjon=${kb4posisjon}"
  sum=$((sum + jolt))
  echo "jolt=${jolt}, sum=${sum}"
done <input_aoc3.txt
echo "${sum}"
