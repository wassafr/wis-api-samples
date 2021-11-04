import {
  CreateIdentityResponse,
  IdentityResponse,
  CreateIdentitySearchResponse,
  IdentitySearchResponse,
  CreateIdentityRecognitionResponse,
  IdentityRecognitionResponse,
  WisError,
} from "../../types";

import axios, { AxiosRequestConfig, AxiosResponse } from "axios";
import FormData from "form-data";
import fs, { PathLike } from "fs";

export async function identityCreateJob(
  token: string,
  inputImages: Array<string>
): Promise<CreateIdentityResponse> {
  let data = new FormData();
  if (Array.isArray(inputImages)) {
    for (let i = 0; i < inputImages.length; i += 1) {
      data.append("input_images", fs.createReadStream(inputImages[i]));
    }
  } else {
    data.append("input_images", fs.createReadStream(inputImages));
  }

  const config: AxiosRequestConfig<any> = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/identity",
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

export async function identityGetJobStatus(
  token: string,
  jobId: string
): Promise<IdentityResponse> {
  const config: AxiosRequestConfig<any> = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/identity",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      job_id: jobId,
    },
  };

  try {
    const response: AxiosResponse<any> = await axios(config);
    return response.data;
  } catch (error: any) {
    throw error as WisError;
  }
}

export async function identityCreateAddImageJob(
  token: string,
  inputImages: Array<string> | string,
  identityId: string
): Promise<CreateIdentityResponse> {
  const data = new FormData();
  if (Array.isArray(inputImages)) {
    for (let i = 0; i < inputImages.length; i += 1) {
      data.append("input_images", fs.createReadStream(inputImages[i]));
    }
  } else {
    data.append("input_images", fs.createReadStream(inputImages));
  }
  data.append("identity_id", identityId);

  const config: AxiosRequestConfig<any> = {
    method: "put",
    url: "https://api.services.wassa.io/innovation-service/identity",
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

export async function identityCreateSearchJob(
  token: string,
  inputImage: string,
  maxResult: number
): Promise<CreateIdentitySearchResponse> {
  const data = new FormData();
  data.append("input_image", fs.createReadStream(inputImage));
  data.append("max_result", JSON.stringify(maxResult));

  const config: AxiosRequestConfig<any> = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/identity/search",
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

export async function identityGetSearchJobStatus(
  token: string,
  jobId: string
): Promise<IdentitySearchResponse> {
  const config: AxiosRequestConfig<any> = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/identity/search",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      job_id: jobId,
    },
  };

  try {
    const response: AxiosResponse<any> = await axios(config);
    return response.data;
  } catch (error: any) {
    throw error as WisError;
  }
}

export async function identityCreateRecognitionJob(
  token: string,
  inputImage: string,
  identityId: string
): Promise<CreateIdentityRecognitionResponse> {
  const data = new FormData();
  data.append("input_image", fs.createReadStream(inputImage));
  data.append("identity_id", identityId);

  const config: AxiosRequestConfig<any> = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/identity/recognize",
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

export async function identityGetRecognitionJobStatus(
  token: string,
  jobId: string
): Promise<IdentityRecognitionResponse> {
  const config: AxiosRequestConfig<any> = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/identity/recognize",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      job_id: jobId,
    },
  };

  try {
    const response: AxiosResponse<any> = await axios(config);
    return response.data;
  } catch (error: any) {
    throw error as WisError;
  }
}

export async function identityDeleteIdentities<T>(
  token: string,
  identityId: Array<string>
): Promise<T | null> {
  const config: AxiosRequestConfig<any> = {
    method: "delete",
    url: "https://api.services.wassa.io/innovation-service/identity",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      identity_id: identityId,
    },
  };

  try {
    const response: AxiosResponse<any> = await axios(config);
    return response.data;
  } catch (error: any) {
    throw error as WisError;
  }
}
