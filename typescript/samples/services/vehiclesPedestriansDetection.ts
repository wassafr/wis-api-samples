import {
  Point,
  CreateVehiclesPedestriansDetectionResponse,
  WisError,
  VehiclesPedestriansDetectionResponse,
} from "../../types";

import axios, { AxiosRequestConfig, AxiosResponse } from "axios";
import FormData from "form-data";
import fs from "fs";

export async function vehiclesPedestriansDetectionCreateJob(
  token: string,
  inputMedia: string,
  expectedClassNames: Array<string>,
  detectionArea?: Array<Point> | null
): Promise<CreateVehiclesPedestriansDetectionResponse> {
  const data = new FormData();
  data.append("input_media", fs.createReadStream(inputMedia));
  data.append("expected_class_names", JSON.stringify(expectedClassNames));
  detectionArea && data.append("detection_area", JSON.stringify(detectionArea));

  const config: AxiosRequestConfig<any> = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/vehicles-pedestrians-detection",
    headers: {
      Authorization: "Bearer " + token,
      ...data.getHeaders(),
    },
    data: data,
  };

  try {
    const response: AxiosResponse<any> = await axios(config);
    return response.data;
  } catch (error: any) {
    throw error as WisError;
  }
}

export async function vehiclesPedestriansDetectionGetJobStatus(
  token: string,
  vehiclePedestrianDetectionJobId: string
): Promise<VehiclesPedestriansDetectionResponse> {
  const config: AxiosRequestConfig<any> = {
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
    const response: AxiosResponse<any> = await axios(config);
    return response.data;
  } catch (error: any) {
    throw error as WisError;
  }
}
