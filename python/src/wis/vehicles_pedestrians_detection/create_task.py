import requests
import json
import os
from typing import List
import mimetypes
# #############################################
from ..wis_constants import wis_service_base_url
from ..wis_exception import WISException
from ..auth import Token
from .class_name import ClassName
# #############################################


def create_task(token: Token, image_path: str, 
    expected_class_names: List[ClassName]=None,
    detection_area: List[dict]=None) -> str:
    """ Create a new process job

        Inputs: 
            token (Token):                  ...
            expected_class_names (list):    ...
            detection_area (list):          ...

        Returns:
            job_id (str):                   ...
    """

    url = wis_service_base_url + "/vehicles-pedestrians-detection"
    headers = { **token.header }
    payload = {}
    if expected_class_names is not None:
        payload.update(expected_class_names=json.dumps([cn.value for cn in expected_class_names]))
    if detection_area is not None:
        payload.update(detection_area=json.dumps(detection_area))

    assert os.path.exists(image_path), 'File not found: %s' % image_path
    files = [
        ('input_media',
            (
                os.path.basename(image_path), 
                open(image_path,'rb'),
                mimetypes.guess_type(image_path)[0]
            )
        )
    ]
    response = requests.request("POST", url, headers=headers, data=payload, files=files)

    if response.status_code == 200:
        return response.json()['vehicle_pedestrian_detection_job_id']
    else:
        raise WISException.from_response(response)
# #############################################

