# Google Cloud Transcription Service

### Functionality
This script has been designed so that, given a FLAC audio file of any length that is stored inside a Google bucket, it will return a transcript of that file. At the present the transcript contains no puncuation although it is a feature enabled within the script. Google offers the puncuation service experimentally at this point and I have failed to see it actually work.

### Requirements
To run this script successfully you will need the following:

1. A Google Cloud account with access credentials to the Speech and Storage APIs
1. Along with this you will need gcloud and gsutil installed on your local system
1. Curl for system requests
1. Jq for JSON parsing

You must change a few parameters at the top of the script to match your setup. Such as the GOOGLE_APPLICATION_CREDENTIALS and FILE variables which will correspond with the locations of the credential file and the audio file.
