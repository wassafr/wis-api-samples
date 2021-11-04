from typing import List
# #############################################
from ..wis_job_status import WISJobStatus
# #############################################

class WISSoilingResult:
    def __init__(self, status: WISJobStatus, 
        dust: float=None, dirt: float=None, 
        gravel: float=None, clod: float=None):

        self.status = status

        self.dust   = dust
        self.dirt   = dirt
        self.gravel = gravel
        self.clod   = clod
    # #############################################

    def __repr__(self) -> str:
        return "<WISSoilingResult %s>" % self.status.name
    # #############################################

    def __bool__(self):
        return self.status == WISJobStatus.succeeded
    # #############################################

    @classmethod
    def from_content(cls, content: dict):
        status      = WISJobStatus(content['status'])
        values      = content.get('result_soiling', {})
        return cls(status, **values)
    # #############################################
