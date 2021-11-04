import { login } from "../../samples/auth/login";
import { soilingCreateJob, soilingGetJobStatus } from "../../samples/services/soiling";

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

    // Create soiling job
    const tryCreateJob = await soilingCreateJob(
      token,
      "./images/soiling.jpeg", // picture
      [
        { x: 0, y: 0 },
        { x: 0.8, y: 0.8 },
        { x: 0, y: 0 },
      ] // soiling area
    );
    const job = tryCreateJob.soiling_job_id as string;

    // Get soiling job status
    await soilingGetJobStatus(token, job);
  } catch (e: any) {
    console.log(e?.message);
  }
};

test();
