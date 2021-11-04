import { login } from "../../samples/auth/login";
import {
  identityCreateJob,
  identityGetJobStatus,
  identityCreateSearchJob,
  identityGetSearchJobStatus,
  identityCreateAddImageJob,
  identityCreateRecognitionJob,
  identityGetRecognitionJobStatus,
  identityDeleteIdentities,
} from "../../samples/services/identity";

import dotenv from "dotenv";
dotenv.config();

const test = async () => {
  try {
    // Get auth token
    const tryLogin = await login(
      process.env.CLIENT_ID as string, // YOUR CLIENT ID
      process.env.SECRET_ID as string // YOUR SECRET ID
    );
    const token = tryLogin.token as string;

    // Create identity job
    const tryCreateIdentityJob = await identityCreateJob(
      token,
      [
        "./images/identity1.jpeg",
        "./images/identity2.jpeg",
      ] // inputImages
    );
    const identityJob = tryCreateIdentityJob.job_id as string;

    // Wait for the job to be handled
    await new Promise(resolve => setTimeout(resolve, 5000));

    // Get identity job status
    const identityJobStatus = await identityGetJobStatus(token, identityJob);
    const identityId = identityJobStatus.identity_id as string;

    // Create identity add image job
    await identityCreateAddImageJob(
      token,
      [
        "./images/identity1.jpeg",
        "./images/identity2.jpeg",
      ], // inputImages
      identityId // identity id
    );

    // Create identity search job
    const tryCreateIdentitySearchJob = await identityCreateSearchJob(
      token,
      "./images/identity2.jpeg", // inputImage
      2 // max result
    );
    const identitySearchJob = tryCreateIdentitySearchJob.job_id as string;

    // Get identity search job status
    await identityGetSearchJobStatus(token, identitySearchJob);

    // Create identity recognition job
    const tryCreateIdentityRecognitionJob = await identityCreateRecognitionJob(
      token,
      "./images/identity2.jpeg", // inputImage
      identityId // identity id
    );
    const identityRecognitionJob =
      tryCreateIdentityRecognitionJob.job_id as string;

    // Get identity recognition job status
    await identityGetRecognitionJobStatus(token, identityRecognitionJob);

    // Delete identity(ies)
    await identityDeleteIdentities(
      token,
      [identityId] // array of identity id(s)
    );
  } catch (e: any) {
    console.log(e?.message);
  }
};

test();
