from ..wis_job_status import WISJobStatus
# #############################################


class WISIdentityResult:
    def __init__(self, status: WISJobStatus, identity_id: str=None):

        self.status         = status
        self.identity_id    = identity_id
    # #############################################

    def __repr__(self) -> str:
        if not self:
            return "<WISIdentityResult %s>" % self.status.name
        else:
            return "<WISIdentityResult %s %4s>" % (
                self.status.name, self.identity_id)
    # #############################################

    def __bool__(self):
        return self.status == WISJobStatus.succeeded
    # #############################################

    @classmethod
    def from_content(cls, content: dict):
        status      = WISJobStatus(content['status'])
        return cls(status, content.get('identity_id'))
    # #############################################
