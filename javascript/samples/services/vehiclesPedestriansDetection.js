import axios from 'axios';
import FormData from 'form-data';
import fs from 'fs';

export async function vehiclesPedestriansDetectionCreateJob(
  token,
  inputMedia,
  expectedClassNames,
  detectionArea = null
) {
  const data = new FormData();
  data.append("input_media", fs.createReadStream(inputMedia));
  data.append("expected_class_names", JSON.stringify(expectedClassNames));
  detectionArea && data.append("detection_area", JSON.stringify(detectionArea));

  const config = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/vehicles-pedestrians-detection",
    headers: {
      Authorization: "Bearer " + token,
      ...data.getHeaders(),
    },
    data: data,
  };

  try {
    const response = await axios(config);
    return response.data;
  } catch (error) {
    throw error;
  }
}

export async function vehiclesPedestriansDetectionGetJobStatus(
  token,
  vehiclePedestrianDetectionJobId
) {
  const config = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/vehicles-pedestrians-detection",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      vehicle_pedestrian_detection_job_id: vehiclePedestrianDetectionJobId,
    },
  };
  
  try {
    const response = await axios(config);
    return response.data;
  } catch (error) {
    throw error;
  }
}
