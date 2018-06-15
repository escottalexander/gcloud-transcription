#!/bin/bash

#TRANSCRIPT=$(jq '.response.results[0].alternatives[0].transcript' copyfile.json)

total=$(jq '.response.results | length' copyfile.json)
count=0
DATE=$(date +%d-%m-%Y" "%H:%M:%S)

echo 'TRANSCRIPT TIMESTAMP '$DATE'' >> fulltranscript.txt
while [ $count -lt $total ]; do
  echo $(jq '.response.results['$count'].alternatives[0].transcript' copyfile.json) | tr -d '"' >> fulltranscript.txt
  count=$(( $count + 1 ))
done
echo 'END OF TRANSCRIPT' >> fulltranscript.txt

code fulltranscript.txt