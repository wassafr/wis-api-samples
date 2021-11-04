import {
  CreateOrientationResponse,
  OrientationResponse,
  WisError,
} from "../../types";
import axios, { AxiosRequestConfig, AxiosResponse } from "axios";
import FormData from "form-data";
import fs from "fs";

export async function orientationCreateJob(
  token: string,
  inputMedia: string
): Promise<CreateOrientationResponse> {
  const data = new FormData();
  data.append("input_media", fs.createReadStream(inputMedia));

  const config: AxiosRequestConfig<any> = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/orientation",
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

export async function orientationGetJobStatus(
  token: string,
  orientationJobId: string
): Promise<OrientationResponse> {
  const config: AxiosRequestConfig<any> = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/orientation",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      orientation_job_id: orientationJobId,
    },
  };

  try {
    const response: AxiosResponse<any> = await axios(config);
    return response.data;
  } catch (error: any) {
    throw error as WisError;
  }
}
