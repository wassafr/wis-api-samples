import axios from 'axios';

export async function logout(token) {
  const config = {
    method: "post",
    url: "https://api.services.wassa.io/logout",
    headers: {
      Authorization: "Bearer " + token,
    },
  };
  
  try {
    const response = await axios(config);
    return response.data;
  } catch (error) {
    throw error;
  }
}
