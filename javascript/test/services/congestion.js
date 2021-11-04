import { login } from "../../samples/auth/login.js";
import {
  congestionCreateJob,
  congestionGetJobStatus,
} from "../../samples/services/congestion.js";
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
    const job = tryCreateJob.congestion_job_id;

    // Get congestion job status
    await congestionGetJobStatus(token, job);
  } catch (e) {
    console.log(e?.message);
  }
};

test();
