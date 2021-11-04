import { login } from "../../samples/auth/login.js";
import {
  orientationCreateJob,
  orientationGetJobStatus,
} from "../../samples/services/orientation.js";
import dotenv from 'dotenv';
dotenv.config();

const test = async () => {
  try {
    // Get auth token
    const tryLogin = await login(
      process.env.CLIENT_ID, // YOUR CLIENT ID
      process.env.SECRET_ID // YOUR SECRET ID
    );
    const token = tryLogin.token;

    // Create orientation job
    const tryCreateJob = await orientationCreateJob(
      token,
      "./images/orientation.jpeg" // input media
    );
    const job = tryCreateJob.orientation_job_id;

    // Get orientation job status
    await orientationGetJobStatus(token, job);
  } catch (e) {
    console.log(e?.message);
  }
};

test();
