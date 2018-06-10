#!/bin/bash

# The Audio File
FILE="gs://cloud-samples-tests/speech/brooklyn.flac"

json="$(curl -X POST \
     -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
     -H "Content-Type: application/json; charset=utf-8" \
     --data "{
  'config': {
    'languageCode': 'en-US',
    'enableAutomaticPunctuation': 'true'
  },
  'audio':{
    'uri':'$FILE'
  }
}" "https://speech.googleapis.com/v1/speech:longrunningrecognize"
)"

cat <<EOF > file.json
$json
EOF

OPCODE=$(jq '.name' file.json)
OPCODE=$(echo $OPCODE | tr -d '"') 
echo $OPCODE

sleep 30

curl -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
     -H "Content-Type: application/json; charset=utf-8" \
     "https://speech.googleapis.com/v1/operations/$OPCODE"

#'gs://escottalexander/output.flac'





