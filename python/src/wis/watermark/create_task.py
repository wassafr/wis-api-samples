import requests
import os
import mimetypes
# #############################################
from .position_preset import WISWatermarkPositionPreset
from ..wis_constants import wis_service_base_url
from ..wis_exception import WISException
from ..auth import Token
# #############################################


def create_task(token: Token, 
    media_path: str, watermark_path: str,
    watermark_transparency: float,
    watermark_ratio: float,
    watermark_position_preset: WISWatermarkPositionPreset
    ) -> str:
    """ Create a new process job

        Inputs: 
            token (Token):                                          ...
            media_path (str):                                       ...
            watermark_path (str):                                   ...
            watermark_transparency (float)                          ...
            watermark_ratio (float)                                 ...
            watermark_position_preset (WISWatermarkPositionPreset)  ...

        Returns:
            job_id (str):                   ...
    """

    assert os.path.exists(media_path), 'File not found: %s' % media_path
    assert os.path.exists(watermark_path), 'File not found: %s' % watermark_path

    url     = wis_service_base_url + "/watermark"
    headers = { **token.header }
    payload = {
        'watermark_transparency' :      watermark_transparency,
        'watermark_ratio' :             watermark_ratio,
        'watermark_position_preset' :   watermark_position_preset.value
    }
    files   = [
        ('input_media', (
            os.path.basename(media_path), 
            open(media_path, 'rb'),
            mimetypes.guess_type(media_path)[0]
        )),
        ('input_watermark', (
            os.path.basename(watermark_path),
            open(watermark_path, 'rb'),
            mimetypes.guess_type(watermark_path)[0]
        ))
    ]

    response = requests.request("POST", url, headers=headers, data=payload, files=files)

    if response.status_code == 200:
        return response.json()['watermark_job_id']
    else:
        raise WISException.from_response(response)
# #############################################

