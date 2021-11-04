import { login } from "../../samples/auth/login";
import {
  congestionCreateJob,
  congestionGetJobStatus,
} from "../../samples/services/congestion";

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

    // Create congestion job
    const tryCreateJob = await congestionCreateJob(
      token,
      "./images/congestion.jpeg", // picture
      [
        { x: 0, y: 0 },
        { x: 0.8, y: 0.8 },
      ], // congestion line
      { top: 0, bottom: 0.5, left: 0, right: 1 } // included area - OPTIONAL PARAMETER
    );
    const job = tryCreateJob.congestion_job_id as string;

    // Get congestion job status
    await congestionGetJobStatus(token, job);
  } catch (e: any) {
    console.log(e?.message);
  }
};

test();
