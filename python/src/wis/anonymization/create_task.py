import requests
import json
import os
import mimetypes
# #############################################
from ..wis_constants import wis_service_base_url
from ..wis_exception import WISException
from ..auth import Token
# #############################################


def create_task(token: Token, media_path: str, 
    activation_faces_blur: bool=True, activation_plates_blur: bool=True,
    output_detections_url: bool=False, included_area: dict=None) -> str:
    """ Create a new process job

        Inputs: 
            token (Token):                  ...
            media_path (str):               ...
            activation_faces_blur (bool):   ...
            activation_plates_blur (bool):  ...
            output_detections_url (bool):   ...
            included_area (dict):           ...

        Returns:
            job_id (str):                   ...
    """

    url = wis_service_base_url + "/anonymization"
    headers = { **token.header }
    payload = {
        'activation_faces_blur':    json.dumps(activation_faces_blur),
        'activation_plates_blur':   json.dumps(activation_plates_blur),
        'output_detections_url':    json.dumps(output_detections_url),
        'included_area':            json.dumps(included_area)
    }

    assert os.path.exists(media_path), 'File not found: %s' % media_path
    files = [
        ('input_media',
            (
                os.path.basename(media_path), 
                open(media_path,'rb'),
                mimetypes.guess_type(media_path)[0]
            )
        )
    ]
    response = requests.request("POST", url, headers=headers, data=payload, files=files)

    if response.status_code == 200:
        return response.json()['anonymization_job_id']
    else:
        raise WISException.from_response(response)
# #############################################

