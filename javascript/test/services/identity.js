import { login } from "../../samples/auth/login.js";
import {
  identityCreateJob,
  identityGetJobStatus,
  identityCreateSearchJob,
  identityGetSearchJobStatus,
  identityCreateAddImageJob,
  identityCreateRecognitionJob,
  identityGetRecognitionJobStatus,
  identityDeleteIdentities,
} from "../../samples/services/identity.js";
import dotenv from 'dotenv';
dotenv.config();

const test = async () => {
  try {
    // Get auth token
    const tryLogin = await login(
      process.env.CLIENT_ID, // YOUR CLIENT ID
      process.env.SECRET_ID // YOUR SECRET ID
    );
    const token = tryLogin.token ;

    // Create identity job
    const tryCreateIdentityJob = await identityCreateJob(
      token,
      [
        "./images/identity1.jpeg",
        "./images/identity2.jpeg",
      ] // inputImages
    );
    const identityJob = tryCreateIdentityJob.job_id;

    // Wait for the job to be handled
    await new Promise(resolve => setTimeout(resolve, 5000));

    // Get identity job status
    const identityJobStatus = await identityGetJobStatus(token, identityJob);
    const identityId = identityJobStatus.identity_id;

    // Create identity add image job
    await identityCreateAddImageJob(
      token,
      ["./images/identity2.jpeg"], // inputImages
      identityId // identity id
    );

    // Create identity search job
    const tryCreateIdentitySearchJob = await identityCreateSearchJob(
      token,
      "./images/identity2.jpeg", // inputImage
      2 // max result
    );
    const identitySearchJob = tryCreateIdentitySearchJob.job_id;

    // Get identity search job status
    await identityGetSearchJobStatus(token, identitySearchJob);

    // Create identity recognition job
    const tryCreateIdentityRecognitionJob = await identityCreateRecognitionJob(
      token,
      "./images/identity2.jpeg", // inputImage
      identityId // identity id
    );
    const identityRecognitionJob =
      tryCreateIdentityRecognitionJob.job_id;

    // Get identity recognition job status
    await identityGetRecognitionJobStatus(token, identityRecognitionJob);

    // Delete identity(ies)
    await identityDeleteIdentities(
      token,
      [identityId] // array of identity id(s)
    );
  } catch (e) {
    console.log(e?.message);
  }
};

test();
