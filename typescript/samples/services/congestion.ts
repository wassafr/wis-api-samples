import {
  Box,
  CongestionResponse,
  CreateCongestionResponse,
  Point,
  WisError,
} from "../../types";

import axios, { AxiosRequestConfig, AxiosResponse } from "axios";
import FormData from "form-data";
import fs from "fs";

export async function congestionCreateJob(
  token: string,
  picture: string,
  congestionLine: Array<Point>,
  includedArea?: Box | null
): Promise<CreateCongestionResponse> {
  const data = new FormData();
  data.append("picture", fs.createReadStream(picture));
  data.append("congestion_line", JSON.stringify(congestionLine));
  includedArea && data.append("included_area", JSON.stringify(includedArea));

  const config: AxiosRequestConfig<any> = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/congestion",
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

export async function congestionGetJobStatus(
  token: string,
  congestionJobId: string
): Promise<CongestionResponse> {
  const config: AxiosRequestConfig<any> = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/congestion",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      congestion_job_id: congestionJobId,
    },
  };

  try {
    const response: AxiosResponse<any> = await axios(config);
    return response.data;
  } catch (error: any) {
    throw error as WisError;
  }
}
