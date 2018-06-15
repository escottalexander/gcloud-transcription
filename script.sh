#!/bin/bash

#Set this to the location of your credentials
export GOOGLE_APPLICATION_CREDENTIALS='/home/elliottalexander/.gconf/Transcription-Service.json'

# The Audio File
FILE='gs://escottalexander/output.flac'

json="$(curl -X POST \
     -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
     -H "Content-Type: application/json; charset=utf-8" \
     --data "{
  'config': {
    'encoding': 'FLAC',
    'sampleRateHertz': '16000',
    'languageCode': 'en-US',
    "enableAutomaticPunctuation": true
      },
  'audio':{
    'uri':'$FILE'
  }
}" "https://speech.googleapis.com/v1/speech:longrunningrecognize"
)"

echo $json

cat <<EOF > file.json
$json
EOF

OPCODE=$(echo $(jq '.name' file.json) | tr -d '"') 
echo "Loading system response for operation $OPCODE"

#TODO: revise load time to be based on file size
#output.flac takes 12min - it is 40 minutes
#better yet, find way to query periodically until file is complete (if .done = true)

count=0
total=46
pstr="[=======================================================================]"

while [ $count -lt $total ]; do
  sleep 0.5 # this is work
  count=$(( $count + 1 ))
  pd=$(( $count * 73 / $total ))
  printf "\r%3d.%1d%% %.${pd}s" $(( $count * 100 / $total )) $(( ($count * 1000 / $total) % 10 )) $pstr
done

response=$(curl -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
     -H "Content-Type: application/json; charset=utf-8" \
     "https://speech.googleapis.com/v1/operations/$OPCODE")

cat <<EOF > file.json
$response
EOF

total=$(jq '.response.results | length' file.json)
count=0
DATE=$(date +%d-%m-%Y" "%H:%M:%S)

echo 'TRANSCRIPT TIMESTAMP: '$DATE'' >> fulltranscript.txt
while [ $count -lt $total ]; do
  echo $(jq '.response.results['$count'].alternatives[0].transcript' file.json) | tr -d '"' >> fulltranscript.txt
  count=$(( $count + 1 ))
done
echo 'END OF TRANSCRIPT' >> fulltranscript.txt

#'gs://cloud-samples-tests/speech/brooklyn.flac'

response=$(curl -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
     -H "Content-Type: application/json; charset=utf-8" \
     "https://speech.googleapis.com/v1/operations/7281258692467443201")



