import axios from 'axios';
import FormData from 'form-data';
import fs from 'fs';

export async function orientationCreateJob(token, inputMedia) {
  const data = new FormData();
  data.append("input_media", fs.createReadStream(inputMedia));

  const config = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/orientation",
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

export async function orientationGetJobStatus(token, orientationJobId) {
  const config = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/orientation",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      orientation_job_id: orientationJobId,
    },
  };
  
  try {
    const response = await axios(config);
    return response.data;
  } catch (error) {
    throw error;
  }
}
