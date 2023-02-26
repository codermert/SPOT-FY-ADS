# Developer by Coder Mert






#!/bin/bash

# check for the OS
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  #Linux
  HOSTFILE="/etc/hosts"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  HOSTFILE="/private/etc/hosts"
else
  echo "Maalesef desteklenmiyor!"
  sleep 1
  exit
fi

HEADER="# Start Spotify AdBlock"
FOOTER="# End Spotify AdBlock"

# check for root privilage
if [ "$EUID" -ne 0 ]
then
  printf "root ayrıcalıkları gerektirir!\nLütfen root olarak çalıştırın."
  sleep 1
  exit
fi

# check if there is old one so we remove it first
line_start=$(grep -n "$HEADER" "$HOSTFILE" | grep -Eo '^[^:]+')
if [ "$line_start" ]
then
  echo "[-] eski komut dosyasını kaldırıyorum..."
  line_end=$(grep -n "$FOOTER" "$HOSTFILE" | grep -Eo '^[^:]+')
  sed -i.bak -e "${line_start},${line_end}d" "$HOSTFILE"
  sleep 1
  echo "[+] yeni komut dosyasını ekliyorum..."
fi

# printing blocker in hostfile
while IFS= read -r LINE || [[ -n "$LINE" ]]
do
  echo $LINE >> $HOSTFILE
done < ./block.txt

echo "Süper! TAMAMLANDI"
exit