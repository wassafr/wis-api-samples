import axios from 'axios';
import FormData from 'form-data';
import fs from 'fs';

export async function facesAttributesCreateJob(token, inputMedia) {
  const data = new FormData();
  data.append("input_media", fs.createReadStream(inputMedia));

  const config = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/faces-attributes",
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

export async function facesAttributesGetJobStatus(token, facesAttributesJobId) {
  const config = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/faces-attributes",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      faces_attributes_job_id: facesAttributesJobId,
    },
  };
  
  try {
    const response = await axios(config);
    return response.data;
  } catch (error) {
    throw error;
  }
}
