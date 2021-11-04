import { login } from "../../samples/auth/login.js";
import { vehiclesPedestriansDetectionCreateJob, vehiclesPedestriansDetectionGetJobStatus } from "../../samples/services/vehiclesPedestriansDetection.js";
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
    const job = tryCreateJob.vehicle_pedestrian_detection_job_id;

    // Get vehicles and pedestrians detection job status
    await vehiclesPedestriansDetectionGetJobStatus(token, job);
  } catch (e) {
    console.log(e?.message);
  }
};

test();
