import axios from 'axios';
import FormData from 'form-data';
import fs from 'fs';

export async function anonymizationCreateJob(
  token,
  fileName,
  activationFacesBlur,
  outputDetectionsUrl,
  includedArea = null
) {
  const data = new FormData();
  data.append("input_media", fs.createReadStream(fileName));
  data.append("activation_faces_blur", JSON.stringify(activationFacesBlur));
  data.append("output_detections_url", JSON.stringify(outputDetectionsUrl));
  includedArea && data.append("included_area", JSON.stringify(includedArea));

  const config = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/anonymization",
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

export async function anonymizationGetJobStatus(token, anonymizationJobId) {
  const config = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/anonymization",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      anonymization_job_id: anonymizationJobId,
    },
  };
  
  try {
    const response = await axios(config);
    return response.data;
  } catch (error) {
    throw error;
  }
}
