import requests
# #############################################
from ..wis_constants import wis_service_base_url
from ..wis_exception import WISException
from ..auth import Token
from .congestion_result import WISCongestionResult
# #############################################

def get_job_status(token: Token, job_id: str) -> WISCongestionResult:
    """ Get Job Status & Result

        Inputs: 
            token (Token):                  ...
            job_id (str):                   ...
        
        Returns:
            status (WISCongestionResult):   ...
    """
    url = wis_service_base_url + "/congestion?congestion_job_id=" + job_id
    headers = { **token.header }
    response = requests.request("GET", url, headers=headers)
    if response.status_code == 200:
        content = response.json()
        if content['status'] != 'Unknown Job':
            return WISCongestionResult.from_content(content)
        else:
            raise WISException(404, 'Unknown Job (bad job_id)')
    else:
        raise WISException.from_response(response)
# #############################################

