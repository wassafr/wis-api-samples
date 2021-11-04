import axios, { AxiosRequestConfig, AxiosResponse } from "axios";
import { Token, WisError } from "../../types";

export async function refreshToken(
  token: string,
  refreshToken: string
): Promise<Token> {
  const data = JSON.stringify({
    refreshToken: refreshToken,
  });

  const config: AxiosRequestConfig<any> = {
    method: "post",
    url: "https://api.services.wassa.io/token",
    headers: {
      Authorization: "Bearer " + token,
      "Content-Type": "application/json",
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
