import {
  CreateSoilingResponse,
  Point,
  SoilingResponse,
  WisError,
} from "../../types";

import axios, { AxiosRequestConfig, AxiosResponse } from "axios";
import FormData from "form-data";
import fs from "fs";

export async function soilingCreateJob(
  token: string,
  picture: string,
  soilingArea: Array<Point>
): Promise<CreateSoilingResponse> {
  const data = new FormData();
  data.append("picture", fs.createReadStream(picture));
  data.append("soiling_area", JSON.stringify(soilingArea));

  const config: AxiosRequestConfig<any> = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/soiling",
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

export async function soilingGetJobStatus(
  token: string,
  soilingJobId: string
): Promise<SoilingResponse> {
  const config: AxiosRequestConfig<any> = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/soiling",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      soiling_job_id: soilingJobId,
    },
  };

  try {
    const response: AxiosResponse<any> = await axios(config);
    return response.data;
  } catch (error: any) {
    throw error as WisError;
  }
}
