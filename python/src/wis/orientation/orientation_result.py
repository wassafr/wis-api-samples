from typing import List
# #############################################
from ..wis_job_status import WISJobStatus
from .wis_orientation import WISOrientation
# #############################################

class WISOrientationResult:
    def __init__(self, status: WISJobStatus, 
        label: WISOrientation=None, confidence: float=None):

        self.status     = status
        self.label      = label
        self.confidence = confidence
    # #############################################

    def __repr__(self) -> str:
        if not self:
            return "<WISOrientationResult %s>" % self.status.name
        else:
            return "<WISOrientationResult %s %s[%.2f]>" % (
                self.status.name, self.label.value, self.confidence)
    # #############################################

    def __bool__(self):
        return self.status == WISJobStatus.succeeded
    # #############################################

    @classmethod
    def from_content(cls, content: dict):
        status      = WISJobStatus(content['status'])
        label       = WISOrientation(content['label']) if (status == WISJobStatus.succeeded) else None
        confidence  = content.get('confidence')
        
        return cls(status, label, confidence)
    # #############################################
