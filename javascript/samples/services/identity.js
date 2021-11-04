import axios from 'axios';
import FormData from 'form-data';
import fs from 'fs';

export async function identityCreateJob(token, inputImages) {
  let data = new FormData();
  if (Array.isArray(inputImages)) {
    for (let i = 0; i < inputImages.length; i += 1) {
      data.append("input_images", fs.createReadStream(inputImages[i]));
    }
  } else {
    data.append("input_images", fs.createReadStream(inputImages));
  }

  const config = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/identity",
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

export async function identityGetJobStatus(token, jobId) {
  const config = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/identity",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      job_id: jobId,
    },
  };

  try {
    const response = await axios(config);
    return response.data;
  } catch (error) {
    throw error;
  }
}

export async function identityCreateAddImageJob(token, inputImages, identityId) {
  const data = new FormData();
  if (Array.isArray(inputImages)) {
    for (let i = 0; i < inputImages.length; i += 1) {
      data.append("input_images", fs.createReadStream(inputImages[i]));
    }
  } else {
    data.append("input_images", fs.createReadStream(inputImages));
  }

  data.append("identity_id", identityId);

  const config = {
    method: "put",
    url: "https://api.services.wassa.io/innovation-service/identity",
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

export async function identityCreateSearchJob(token, inputImage, maxResult) {
  const data = new FormData();
  data.append("input_image", fs.createReadStream(inputImage));
  data.append("max_result", JSON.stringify(maxResult));

  const config = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/identity/search",
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

export async function identityGetSearchJobStatus(token, jobId) {
  const config = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/identity/search",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      job_id: jobId,
    },
  };

  try {
    const response = await axios(config);
    return response.data;
  } catch (error) {
    throw error;
  }
}

export async function identityCreateRecognitionJob(token, inputImage, identityId) {
  const data = new FormData();
  data.append("input_image", fs.createReadStream(inputImage));
  data.append("identity_id", identityId);

  const config = {
    method: "post",
    url: "https://api.services.wassa.io/innovation-service/identity/recognize",
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

export async function identityGetRecognitionJobStatus(token, jobId) {
  const config = {
    method: "get",
    url: "https://api.services.wassa.io/innovation-service/identity/recognize",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      job_id: jobId,
    },
  };

  try {
    const response = await axios(config);
    return response.data;
  } catch (error) {
    throw error;
  }
}

export async function identityDeleteIdentities(token, identityId) {
  const config = {
    method: "delete",
    url: "https://api.services.wassa.io/innovation-service/identity",
    headers: {
      Authorization: "Bearer " + token,
    },
    params: {
      identity_id: identityId,
    },
  };
  
  try {
    const response = await axios(config);
    return response.data;
  } catch (error) {
    throw error;
  }
}
