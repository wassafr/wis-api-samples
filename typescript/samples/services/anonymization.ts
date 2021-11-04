import {
  AnonymizationResponse,
  Box,
  CreateAnonymizationResponse,
  WisError,
} from "../../types";
import FormData from "form-data";
import fs from "fs";
import axios, { AxiosRequestConfig, AxiosResponse } from "axios";

export async function anonymizationCreateJob(
  token: string,
  fileName: string,
  activationFacesBlur: boolean,
  outputDetectionsUrl: boolean,
  includedArea?: Box | null
): Promise<CreateAnonymizationResponse> {
  const data = new FormData();
  data.append("input_media", fs.createReadStream(fileName));
  data.append("activation_faces_blur", JSON.stringify(activationFacesBlur));
  data.append("output_detections_url", JSON.stringify(outputDetectionsUrl));
  includedArea && data.append("included_area", JSON.stringify(includedArea));

  const config: AxiosRequestConfig<any> = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/anonymization",
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

export async function anonymizationGetJobStatus(
  token: string,
  anonymizationJobId: string
): Promise<AnonymizationResponse> {
  const config: AxiosRequestConfig<any> = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/anonymization",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      anonymization_job_id: anonymizationJobId,
    },
  };

  try {
    const response: AxiosResponse<any> = await axios(config);
    return response.data;
  } catch (error: any) {
    throw error as WisError;
  }
}
