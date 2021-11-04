import axios from 'axios';

export async function getResultFile(token, fileName) {
  const config = {
    method: "get",
    url: `https://api.services.wassa.io/innovation-service/result/${fileName}`,
    headers: {
      Authorization: "Bearer " + token,
    }
  };
  
  try {
    const response = await axios(config);
    return response.data;
  } catch (error) {
    throw error;
  }
}
