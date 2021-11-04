import { login } from "../../samples/auth/login.js";
import { soilingCreateJob, soilingGetJobStatus } from "../../samples/services/soiling.js";
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
    const job = tryCreateJob.soiling_job_id;

    // Get soiling job status
    await soilingGetJobStatus(token, job);
  } catch (e) {
    console.log(e?.message);
  }
};

test();
