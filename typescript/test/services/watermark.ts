import { login } from "../../samples/auth/login";
import {
  watermarkCreateJob,
  watermarkGetJobStatus,
} from "../../samples/services/watermark";

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

    // Create watermark job
    const tryCreateJob = await watermarkCreateJob(
      token,
      "./images/watermark/input_media.jpeg", // image
      "./images/watermark/input_watermark.jpeg", // watermark image
      0.8, // transparency
      0.3, // watermark ratio
      "upper_right" // watermark position
    );
    const job = tryCreateJob.watermark_job_id as string;

    // Get watermark job status
    await watermarkGetJobStatus(token, job);
  } catch (e: any) {
    console.log(e?.message);
  }
};

test();
