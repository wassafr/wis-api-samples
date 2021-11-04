import {
  CreateWatermarkResponse,
  WatermarkResponse,
  WisError,
} from "../../types";

import axios, { AxiosRequestConfig, AxiosResponse } from "axios";
import FormData from "form-data";
import fs from "fs";

export async function watermarkCreateJob(
  token: string,
  inputMedia: string,
  inputWatermark: string,
  transparency: number,
  ratio: number,
  position: string
): Promise<CreateWatermarkResponse> {
  const data = new FormData();
  data.append("input_media", fs.createReadStream(inputMedia));
  data.append("input_watermark", fs.createReadStream(inputWatermark));
  data.append("watermark_transparency", JSON.stringify(transparency));
  data.append("watermark_ratio", JSON.stringify(ratio));
  data.append("watermark_position_preset", position);

  const config: AxiosRequestConfig<any> = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/watermark",
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

export async function watermarkGetJobStatus(
  token: string,
  watermarkJobId: string
): Promise<WatermarkResponse> {
  const config: AxiosRequestConfig<any> = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/watermark",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      watermark_job_id: watermarkJobId,
    },
  };

  try {
    const response: AxiosResponse<any> = await axios(config);
    return response.data;
  } catch (error: any) {
    throw error as WisError;
  }
}
