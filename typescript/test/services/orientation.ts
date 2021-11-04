import { login } from "../../samples/auth/login";
import {
  orientationCreateJob,
  orientationGetJobStatus,
} from "../../samples/services/orientation";

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

    // Create orientation job
    const tryCreateJob = await orientationCreateJob(
      token,
      "./images/orientation.jpeg" // input media
    );
    const job = tryCreateJob.orientation_job_id as string;

    // Get orientation job status
    await orientationGetJobStatus(token, job);
  } catch (e: any) {
    console.log(e?.message);
  }
};

test();
