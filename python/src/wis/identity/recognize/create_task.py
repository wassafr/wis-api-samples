import requests
import os
import mimetypes
# #############################################
from ...wis_constants import wis_service_base_url
from ...wis_exception import WISException
from ...auth import Token
# #############################################


def create_task(token: Token, identity_id: str, image_path: str) -> str:
    """ Create a recognition task

        Inputs: 
            token (Token):          ...
            identity_id (str):      ...
            image_path (str):       ...

        Returns:
            job_id (str):           ...
    """

    url     = wis_service_base_url + "/identity/recognize"
    headers = { **token.header }
    payload = { 'identity_id': identity_id }

    assert os.path.exists(image_path), 'File not found: %s' % image_path
    files = [
        ('input_image',
            (
                os.path.basename(image_path), 
                open(image_path,'rb'),
                mimetypes.guess_type(image_path)[0]
            )
        )
    ]
    response = requests.request("POST", url, headers=headers, data=payload, files=files)

    if response.status_code == 200:
        return response.json()['job_id']
    else:
        raise WISException.from_response(response)
# #############################################

