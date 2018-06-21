# Google Cloud Transcription Service

### Functionality
This script has been designed so that, given a FLAC audio file of any length that is stored inside a Google bucket, it will return a transcript of that file. At the present the transcript contains no puncuation although it is a feature enabled within the script. Google offers the puncuation service experimentally at this point and I have failed to see it actually work.

### Requirements
To run this script successfully you will need the following:

1. Set up gcloud. Following this [quickstart guide](https://cloud.google.com/speech-to-text/docs/quickstart-gcloud) will have you on your way
1. Along with this you will need gsutil for managing Google buckets. Here is the [quickstart guide](https://cloud.google.com/storage/docs/quickstart-gsutil)
1. Install cURL for API requests. [How to install cURL on (your system)](https://www.google.com/search?ei=CxAsW4vrLIqJjwSeh5n4Cw&q=how+to+install+curl+on+&oq=how+to+install+curl+on+&gs_l=psy-ab.3..0l10.17066.17066.0.17369.1.1.0.0.0.0.119.119.0j1.1.0....0...1.1.64.psy-ab..0.1.119....0.LVrjkk2jxmI)
1. Install Jq for JSON parsing. Read about it [here](https://stedolan.github.io/jq/)

You must change a few parameters at the top of the script to match your setup. Such as the GOOGLE_APPLICATION_CREDENTIALS and FILE variables which will correspond with the locations of the credential file and the audio file.
