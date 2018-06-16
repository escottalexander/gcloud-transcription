#!/bin/bash

#Set this to the location of your credentials
export GOOGLE_APPLICATION_CREDENTIALS='/home/elliottalexander/.gconf/Transcription-Service.json'

# The Audio File
FILE='gs://escottalexander/output.flac'

filesize=$(echo $(gsutil du $FILE)| cut -d " " -f 1)

json="$(curl --silent -X POST \
     -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
     -H "Content-Type: application/json; charset=utf-8" \
     --data "{
  'config': {
    'encoding': 'FLAC',
    'sampleRateHertz': '16000',
    'languageCode': 'en-US',
    'enableAutomaticPunctuation': true
      },
  'audio':{
    'uri':'$FILE'
  }
}" "https://speech.googleapis.com/v1/speech:longrunningrecognize"
)"

cat <<EOF > file.json
$json
EOF

OPCODE=$(echo $(jq '.name' file.json) | tr -d '"') 
echo "Loading system response for operation #$OPCODE"
echo "Waiting for progress percentage"

loadtime=$(($filesize / 65000))
if [ $loadtime -lt 30 ]
then
loadtime=30
fi

if [ $loadtime -gt 300 ]
then
  longload=true
else
  longload=false
fi  

isdone=$(jq '.done' file.json)

while [ "$isdone" = null ]
do
if [ $longload ]
then
  sleep $((loadtime/15))
else
  sleep $((loadtime/6))
fi  
response=$(curl --silent -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
     -H "Content-Type: application/json; charset=utf-8" \
     "https://speech.googleapis.com/v1/operations/$OPCODE")

cat <<EOF > file.json
$response
EOF

if [ $(jq '.metadata.progressPercent' file.json) != null ]
then
echo -e "\e[1A $(jq '.metadata.progressPercent' file.json)% Complete                                "
isdone=$(jq '.done' file.json)
fi
done

total=$(jq '.response.results | length' file.json)
count=0
DATE=$(date +%d-%m-%Y" "%H:%M:%S)
echo 'TRANSCRIPT TIMESTAMP: '$DATE'' >> fulltranscript.txt
while [ "$count" -lt "$total" ]; do
  echo $(jq '.response.results['$count'].alternatives[0].transcript' file.json) | tr -d '"' >> fulltranscript.txt
  count=$(( $count + 1 ))
done
echo 'END OF TRANSCRIPT' >> fulltranscript.txt

# For testing purposes
#'gs://cloud-samples-tests/speech/brooklyn.flac'




