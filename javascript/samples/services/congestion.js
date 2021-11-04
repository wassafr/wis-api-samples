import axios from 'axios';
import FormData from 'form-data';
import fs from 'fs';

export async function congestionCreateJob(
  token,
  picture,
  congestionLine,
  includedArea = null
) {
  const data = new FormData();
  data.append("picture", fs.createReadStream(picture));
  data.append("congestion_line", JSON.stringify(congestionLine));
  includedArea && data.append("included_area", JSON.stringify(includedArea));

  const config = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/congestion",
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

export async function congestionGetJobStatus(token, congestionJobId) {
  const config = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/congestion",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      congestion_job_id: congestionJobId,
    },
  };
  
  try {
    const response = await axios(config);
    return response.data;
  } catch (error) {
    throw error;
  }
}
