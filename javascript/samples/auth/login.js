import axios from 'axios';

export async function login(clientId, secretId) {
  const data = JSON.stringify({
    clientId: clientId,
    secretId: secretId,
  });

  const config = {
    method: "post",
    url: "https://api.services.wassa.io/login",
    headers: {
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
