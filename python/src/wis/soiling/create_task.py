import requests
import json
import os
from typing import List
import mimetypes
# #############################################
from ..wis_constants import wis_service_base_url
from ..wis_exception import WISException
from ..auth import Token
# #############################################


def create_task(token: Token, image_path: str, soiling_area: List[dict]) -> str:
    """ Create a new process job

        Inputs: 
            token (Token):          ...
            image_path (str):       ...
            soiling_area (list):    ...

        Returns:
            job_id (str):           ...
    """

    url = wis_service_base_url + "/soiling"
    headers = { **token.header }
    payload = { 'soiling_area': json.dumps(soiling_area) }
    
    assert os.path.exists(image_path), 'File not found: %s' % image_path
    files = [
        ('picture',
            (
                os.path.basename(image_path), 
                open(image_path,'rb'),
                mimetypes.guess_type(image_path)[0]
            )
        )
    ]
    response = requests.request("POST", url, headers=headers, data=payload, files=files)

    if response.status_code == 200:
        return response.json()['soiling_job_id']
    else:
        raise WISException.from_response(response)
# #############################################

