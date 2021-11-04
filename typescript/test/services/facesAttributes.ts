import { login } from "../../samples/auth/login";
import {
  facesAttributesCreateJob,
  facesAttributesGetJobStatus,
} from "../../samples/services/facesAttributes";

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

    // Create faces attributes job
    const tryCreateJob = await facesAttributesCreateJob(
      token,
      "./images/faces_attributes.jpg" // input media
    );
    const job = tryCreateJob.faces_attributes_job_id as string;

    // Get faces attributes job status
    await facesAttributesGetJobStatus(token, job);
  } catch (e: any) {
    console.log(e?.message);
  }
};

test();
