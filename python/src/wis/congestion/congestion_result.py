from typing import List
# #############################################
from ..wis_job_status import WISJobStatus
# #############################################

class WISCongestionResult:
    def __init__(self, status: WISJobStatus, vehicles: List[str]=None):
        self.status = status
        self.vehicles = vehicles
    # #############################################

    def __repr__(self) -> str:
        return "<WISCongestionResult %s>" % self.status.name
    # #############################################

    def __bool__(self):
        return self.status == WISJobStatus.succeeded
    # #############################################

    @classmethod
    def from_content(cls, content: dict):
        status      = WISJobStatus(content['status'])
        vehicles    = content.get('vehicles')

        return cls(status, vehicles)
    # #############################################
