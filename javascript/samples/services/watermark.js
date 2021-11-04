import axios from 'axios';
import FormData from 'form-data';
import fs from 'fs';

export async function watermarkCreateJob(
  token,
  inputMedia,
  inputWatermark,
  transparency,
  ratio,
  position
) {
  const data = new FormData();
  data.append("input_media", fs.createReadStream(inputMedia));
  data.append("input_watermark", fs.createReadStream(inputWatermark));
  data.append("watermark_transparency", JSON.stringify(transparency));
  data.append("watermark_ratio", JSON.stringify(ratio));
  data.append("watermark_position_preset", position);

  const config = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/watermark",
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

export async function watermarkGetJobStatus(token, watermarkJobId) {
  const config = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/watermark",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      watermark_job_id: watermarkJobId,
    },
  };

  try {
    const response = await axios(config);
    return response.data;
  } catch (error) {
    throw error;
  }
}
