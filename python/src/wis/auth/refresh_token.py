import requests
import json
# #############################################
from ..wis_constants import wis_base_url
from ..wis_exception import WISException
from .token import Token
# #############################################

def refresh_token(token: Token) -> Token:
    """ Refresh Token
        Returns a new token object

        Inputs: 
            token (Token):      ...
        
        Returns:
            token (Token):      ...
    """

    url = wis_base_url + "/token"
    payload = json.dumps({ "refreshToken": token.refresh_token })
    headers = {
        ** token.header,
        'Content-Type': 'application/json'
    }

    response = requests.request("POST", url, headers=headers, data=payload)

    if response.status_code == 200:
        return Token(**response.json())
    else:
        raise WISException.from_response(response)
# #############################################