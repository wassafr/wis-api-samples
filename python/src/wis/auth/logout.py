import requests
# #############################################
from ..wis_constants import wis_base_url
from ..wis_exception import WISException
from .token import Token
# #############################################


def logout(token: Token):
    """ Logout

        Inputs:
            token (Token):      ...
    """

    url = wis_base_url + "/logout"
    payload = {}
    headers = { **token.header }
    response = requests.request("POST", url, headers=headers, data=payload)

    if response.status_code != 204:
        raise WISException.from_response(response)
# #############################################
