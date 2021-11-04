import requests
import json
# #############################################
from ..wis_constants import wis_base_url, wis_client_id, wis_secret_id
from ..wis_exception import WISException
from .token import Token
# #############################################


def login(client_id: str=None, secret_id: str=None) -> Token:
    """ Hask for a new valid token

        Inputs: 
            url (str):          ...
            client_id (str):    ...
            secret_id (str):    ...
        
        Returns:
            token (Token):      ...
    """

    url = wis_base_url + "/login"
    payload = json.dumps({
        "clientId": client_id or wis_client_id,
        "secretId": secret_id or wis_secret_id
    })
    headers = {
        'Content-Type': 'application/json'
    }
    response = requests.request("POST", url, headers=headers, data=payload)

    if response.status_code == 200:
        return Token(**response.json())
    else:
        raise WISException.from_response(response)
# #############################################
