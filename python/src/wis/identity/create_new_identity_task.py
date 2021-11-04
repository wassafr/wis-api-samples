import requests
import os
from typing import List
import mimetypes
# #############################################
from ..wis_constants import wis_service_base_url
from ..wis_exception import WISException
from ..auth import Token
# #############################################


def create_new_identity_task(token: Token, image_pathes: List[str]) -> str:
    """ Create a new identity process job

        Inputs: 
            token (Token):          ...
            image_pathes (list):    ...

        Returns:
            job_id (str):           ...
    """

    # check that image files exist
    for image_path in image_pathes:
        assert os.path.exists(image_path), 'File not found: %s' % image_path

    url         = wis_service_base_url + "/identity"
    headers     = { **token.header }
    payload     = {}
    files       = [
        ('input_images',
            (
                os.path.basename(image_path), 
                open(image_path,'rb'),
                mimetypes.guess_type(image_path)[0]
            )
        )
        for image_path in image_pathes
    ]
    response    = requests.request("POST", url, headers=headers, data=payload, files=files)

    if response.status_code == 200:
        return response.json()['job_id']
    else:
        raise WISException.from_response(response)
# #############################################
