import requests
from typing import Union
# #############################################
from ..wis_exception import WISException
from ..auth import Token
# #############################################


def get_result_file(token: Token, url: str) -> Union[str, bytes]:
    """ Get the result file content
        You can save it in a file

        Inputs: 
            token (Token):                      ...
            url (str):                          ...
        
        Returns:
            file_content (str | bytes):         ...
    """
    headers     = { **token.header }
    response    = requests.request("GET", url, headers=headers)
    mime_type   = response.headers['Content-Type']
    is_text     = mime_type.startswith('text/') or \
        mime_type in {'application/json'}
    if response.status_code == 200:
        return response.text if is_text else response.content
    else:
        raise WISException.from_response(response)        
# #############################################
