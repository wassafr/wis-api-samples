import { ResultFileResponse, WisError } from "../../types";

import axios, { AxiosRequestConfig, AxiosResponse } from "axios";

export async function getResultFile(
  token: string,
  fileName: string
): Promise<ResultFileResponse> {
  const config: AxiosRequestConfig<any> = {
    method: "get",
    url: `https://api.services.wassa.io/innovation-service/result/${fileName}`,
    headers: {
      Authorization: "Bearer " + token,
    },
  };

  try {
    const response: AxiosResponse<any> = await axios(config);
    return response.data;
  } catch (error: any) {
    throw error as WisError;
  }
}
