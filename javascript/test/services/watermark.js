import { login } from "../../samples/auth/login.js";
import {
  watermarkCreateJob,
  watermarkGetJobStatus,
} from "../../samples/services/watermark.js";
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

    // Create watermark job
    const tryCreateJob = await watermarkCreateJob(
      token,
      "./images/watermark/input_media.jpeg", // image
      "./images/watermark/input_watermark.jpeg", // watermark image
      0.8, // transparency
      0.3, // watermark ratio
      "upper_right" // watermark position
    );
    const job = tryCreateJob.watermark_job_id;

    // Get watermark job status
    await watermarkGetJobStatus(token, job);
  } catch (e) {
    console.log(e?.message);
  }
};

test();
