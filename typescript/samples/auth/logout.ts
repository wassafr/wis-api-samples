import axios, { AxiosRequestConfig, AxiosResponse } from "axios";
import { WisError } from "../../types";

export async function logout<T>(token: string): Promise<T | null> {
  const config: AxiosRequestConfig<any> = {
    method: "post",
    url: "https://api.services.wassa.io/logout",
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
