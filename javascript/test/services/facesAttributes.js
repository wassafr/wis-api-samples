import { login } from "../../samples/auth/login.js";
import {
  facesAttributesCreateJob,
  facesAttributesGetJobStatus,
} from "../../samples/services/facesAttributes.js";
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

    // Create faces attributes job
    const tryCreateJob = await facesAttributesCreateJob(
      token,
      "./images/faces_attributes.jpg" // input media
    );
    const job = tryCreateJob.faces_attributes_job_id;

    // Get faces attributes job status
    await facesAttributesGetJobStatus(token, job);
  } catch (e) {
    console.log(e?.message);
  }
};

test();
