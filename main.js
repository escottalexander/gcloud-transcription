// Imports the Google Cloud client library
const speech = require('@google-cloud/speech');
const Storage = require('@google-cloud/storage');
const fs = require('fs');
var sox = require('sox');

// Creates a client
const storage = new Storage({
    projectId: 'node-gcp-transcription',
  keyFilename: '~.gconf/Transcription-Service.json'
});
const client = new speech.SpeechClient();

// // these options are all default, you can leave any of them off
// var job = sox.transcode('source.wav', 'output.flac', {
//     sampleRate: 16000,
//     format: 'flac',
//   });
//   job.on('error', function(err) {
//     console.error(err);
//   });
//   job.on('progress', function(amountDone, amountTotal) {
//     console.log("progress", amountDone, amountTotal);
//   });
//   job.on('src', function(info) {
//     /* info looks like:
//     {
//       format: 'wav',
//       duration: 1.5,
//       sampleCount: 66150,
//       channelCount: 1,
//       bitRate: 722944,
//       sampleRate: 44100,
//     }
//     */
//   });
//   job.on('dest', function(info) {
//     /* info looks like:
//     {
//       sampleRate: 44100,
//       format: 'mp3',
//       channelCount: 2,
//       sampleCount: 67958,
//       duration: 1.540998,
//       bitRate: 196608,
//     }
//     */
//   });
//   job.on('end', function() {
//       /**
//  * TODO(developer): Uncomment the following lines before running the sample.
//  */
// // const bucketName = 'Name of a bucket, e.g. my-bucket';
//  const filename = 'Local file to upload, e.g. ./local/path/to/file.txt';

// // Uploads a local file to the bucket
// storage
// .bucket(bucketName)
// .upload(filename)
// .then(() => {
//   console.log(`${filename} uploaded to ${bucketName}.`);
// })
// .catch(err => {
//   console.error('ERROR:', err);
// });
//     console.log("all done");
//   });

// The name of the audio file to transcribe



// Reads a local audio file and converts it to base64
//const file = fs.readFileSync(fileName).toString('base64');
const uri = 'gs://escottalexander/output.flac';
// The audio file's encoding, sample rate in hertz, and BCP-47 language code
const audio = {
  uri: uri,
};
const config = {
  encoding: 'FLAC',
  sampleRateHertz: 16000,
  languageCode: 'en-US',
  useEnhanced: true,
  enableAutomaticPunctuation: true
};
const request = {
  audio: audio,
  config: config,
};

// Detects speech in long running file
client
  .longRunningRecognize(request)
  .then(data => {
    const operation = data[0];
    // Get a Promise representation of the final result of the job
    return operation.promise();
  })
  .then(data => {
    const response = data[0];
    const transcription = response.results
      .map(result => result.alternatives[0].transcript)
      .join('\n');
      fs.appendFile('transcript.txt', transcription, function(err){
        if (err) throw err;
    })
    console.log(`Transcription: ${transcription}`);
  })
  .catch(err => {
    console.error('ERROR:', err);
  });
