import { login } from "../../samples/auth/login";
import { vehiclesPedestriansDetectionCreateJob, vehiclesPedestriansDetectionGetJobStatus } from "../../samples/services/vehiclesPedestriansDetection";

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

    // Create vehicles and pedestrians detection job
    const tryCreateJob = await vehiclesPedestriansDetectionCreateJob(
      token,
      "./images/VAP.jpg", // input media
      ["pedestrian"], // expected class names
      [
        { x: 0.1, y: 0.2 },
        { x: 0.1, y: 0.3 },
        { x: 0.1, y: 0 }
      ] // detection area - OPTIONAL PARAMETER
    );
    const job = tryCreateJob.vehicle_pedestrian_detection_job_id as string;

    // Get vehicles and pedestrians detection job status
    await vehiclesPedestriansDetectionGetJobStatus(token, job);
  } catch (e: any) {
    console.log(e?.message);
  }
};

test();
