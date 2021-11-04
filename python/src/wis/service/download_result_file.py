import os
# #############################################
from ..auth import Token
from .get_result_file import get_result_file
# #############################################


def download_result_file(token: Token, url: str, dst_folder: str) -> str:
    """ Download result file and save it localy in the provided folder

        Inputs: 
            token (Token):                      ...
            url (str):                          ...
        
        Returns:
            file_path (str):                    ...
    """
    content   = get_result_file(token, url)
    filename  = os.path.basename(url)
    file_path = os.path.join(dst_folder, filename)
    file_mode = 'wb' if isinstance(content, bytes) else 'w'
    with open(file_path, file_mode) as file:
        file.write(content)
    return file_path
# #############################################
