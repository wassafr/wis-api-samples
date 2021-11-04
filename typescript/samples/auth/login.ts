import axios, { AxiosRequestConfig, AxiosResponse } from "axios";
import { WisError, Token } from "../../types";

export async function login(
  clientId: string,
  secretId: string
): Promise<Token> {
  const data = JSON.stringify({
    clientId: clientId,
    secretId: secretId,
  });

  const config: AxiosRequestConfig<any> = {
    method: "post",
    url: "https://api.services.wassa.io/login",
    headers: {
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
