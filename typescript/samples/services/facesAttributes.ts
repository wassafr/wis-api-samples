import {
  CreateFacesAttributesResponse,
  FacesAttributesResponse,
  WisError,
} from "../../types";
import axios, { AxiosRequestConfig, AxiosResponse } from "axios";
import FormData from "form-data";
import fs from "fs";

export async function facesAttributesCreateJob(
  token: string,
  inputMedia: string
): Promise<CreateFacesAttributesResponse> {
  const data = new FormData();
  data.append("input_media", fs.createReadStream(inputMedia));

  const config: AxiosRequestConfig<any> = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/faces-attributes",
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

export async function facesAttributesGetJobStatus(
  token: string,
  facesAttributesJobId: string
): Promise<FacesAttributesResponse> {
  const config: AxiosRequestConfig<any> = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/faces-attributes",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      faces_attributes_job_id: facesAttributesJobId,
    },
  };

  try {
    const response: AxiosResponse<any> = await axios(config);
    return response.data;
  } catch (error: any) {
    throw error as WisError;
  }
}
