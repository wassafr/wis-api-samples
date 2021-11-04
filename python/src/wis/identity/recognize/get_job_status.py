import requests
# #############################################
from ...wis_constants import wis_service_base_url
from ...wis_exception import WISException
from ...auth import Token
from .recognize_result import WISRecognizeResult
# #############################################

def get_job_status(token: Token, job_id: str) -> WISRecognizeResult:
    """ Get Job Status & Result

        Inputs: 
            token (Token):                  ...
            job_id (str):                   ...
        
        Returns:
            status (WISRecognizeResult):   ...
    """
    url = wis_service_base_url + "/identity/recognize?job_id=" + job_id
    headers = { **token.header }
    response = requests.request("GET", url, headers=headers)
    if response.status_code == 200:
        content = response.json()
        if content['status'] != 'Unknown Job':
            return WISRecognizeResult.from_content(content)
        else:
            raise WISException(404, 'Unknown Job (bad job_id)')
    else:
        raise WISException.from_response(response)
# #############################################

