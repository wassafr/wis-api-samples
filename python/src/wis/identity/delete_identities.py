import requests
from typing import List
# #############################################
from ..wis_constants import wis_service_base_url
from ..wis_exception import WISException
from ..auth import Token
# #############################################


def delete_identities(token: Token, identity_ids: List[str]) -> str:
    """ Create a new identity process job

        Inputs: 
            token (Token):          ...
            identity_ids (list):    ...
    """

    params      = '&'.join([
        "identity_id[%d]=%s" % (iid, identity_ids)
        for iid, identity_ids 
        in enumerate(identity_ids)
    ])
    url         = wis_service_base_url + "/identity?" + params        
    headers     = { **token.header }
    payload     = {}
    response    = requests.request("DELETE", url, headers=headers, data=payload)

    if response.status_code != 204:
        raise WISException.from_response(response)
# #############################################
