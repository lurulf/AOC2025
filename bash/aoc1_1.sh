#!/bin/bash
set -eufo pipefail

posisjon=50
teller=0
linje=1
while IFS= read -r data; do
  # printf "%-5s: %-5s " "${linje}" "${data}"
  mengde="${data:1}"
  # printf "%-5s " "${mengde}"
  mengde="$((mengde % 100))"
  # printf "%5s " "${posisjon}"
  case "${data:0:1}" in
    R)
      posisjon="$((posisjon + mengde))"
      # printf "+"
      ;;
    L)
      posisjon="$((posisjon - mengde))"
      # printf "-"
      ;;
    *)
      echo "Feil inndata: ${data}"
      exit 1
      ;;
  esac
  printf " %2s = %-4s " "${mengde}" "${posisjon}"
  if ((posisjon < 0)); then
    posisjon=$((posisjon+100))
  else
    posisjon=$((posisjon % 100))
  fi
  # printf "==> %-5s " "${posisjon}"
  if ((posisjon == 0)); then
    teller=$((teller+1))
  fi
  # printf "%-5s\n" "${teller}"
  linje=$((linje+1))
done < input_aoc1.txt
echo "nuller: ${teller}"
