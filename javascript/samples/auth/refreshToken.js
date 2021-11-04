import axios from 'axios';

export async function refreshToken(token, refreshToken) {
  const data = JSON.stringify({
    refreshToken: refreshToken
  });

  const config = {
    method: "post",
    url: "https://api.services.wassa.io/token",
    headers: {
      Authorization: "Bearer " + token,
      "Content-Type": "application/json",
    },
    data: data,
  };

  try {
    const response = await axios(config);
    return response.data;
  } catch (error) {
    throw error;
  }
}
