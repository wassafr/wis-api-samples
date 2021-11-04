import { login } from "../../samples/auth/login";
import {
  anonymizationCreateJob,
  anonymizationGetJobStatus,
} from "../../samples/services/anonymization";
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

    // Create anonymization job
    const tryCreateJob = await anonymizationCreateJob(
      token,
      "./images/anonymization.jpeg", // fileName
      true, // activationFacesBlur
      true, // outputDetectionsUrl
      { left: 0, right: 0.5, top: 0, bottom: 1 } // includedArea - OPTIONAL PARAMETER
    );
    const job = tryCreateJob.anonymization_job_id as string;

    // Get anonymization job status
    await anonymizationGetJobStatus(token, job);
  } catch (e: any) {
    console.log(e?.message);
  }
};

test();
