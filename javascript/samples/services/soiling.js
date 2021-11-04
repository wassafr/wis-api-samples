import axios from 'axios';
import FormData from 'form-data';
import fs from 'fs';

export async function soilingCreateJob(token, picture, soilingArea) {
  const data = new FormData();
  data.append("picture", fs.createReadStream(picture));
  data.append("soiling_area", JSON.stringify(soilingArea));

  const config = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/soiling",
    headers: {
      Authorization: "Bearer " + token,
      ...data.getHeaders(),
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

export async function soilingGetJobStatus(token, soilingJobId) {
  const config = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/soiling",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      soiling_job_id: soilingJobId,
    },
  };

  try {
    const response = await axios(config);
    return response.data;
  } catch (error) {
    throw error;
  }
}
