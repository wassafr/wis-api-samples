from typing import List
from ...wis_job_status import WISJobStatus
# #############################################


class WISIdentity:
    def __init__(self, identity_id: str, score: float):
        self.identity_id    = identity_id
        self.score          = score

    def __repr__(self):
        return "<WISIdentity %.2f %s>" % (self.score, self.identity_id)
# #############################################


class WISSearchResult:
    def __init__(self, status: WISJobStatus, identities: List[WISIdentity]=None):

        self.status         = status
        self.identities     = identities
    # #############################################

    def __repr__(self) -> str:
        if not self:
            return "<WISSearchResult %s>" % self.status.name
        else:
            nb = len(self.identities) if self.identities else 0
            return "<WISSearchResult %s #%d>" % (self.status.name, nb)
    # #############################################

    def __bool__(self):
        return self.status == WISJobStatus.succeeded
    # #############################################

    @classmethod
    def from_content(cls, content: dict):
        status      = WISJobStatus(content['status'])
        identities  = [WISIdentity(**result) for result in content.get('results', [])]
        return cls(status, identities)
    # #############################################
