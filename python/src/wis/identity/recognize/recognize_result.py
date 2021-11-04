from ...wis_job_status import WISJobStatus
# #############################################


class WISRecognizeResult:
    def __init__(self, status: WISJobStatus,
        identity_id: str=None, score: float=None, recognition: bool=None):

        self.status         = status
        self.identity_id    = identity_id
        self.score          = score
        self.recognition    = recognition
    # #############################################

    def __repr__(self) -> str:
        if not self:
            return "<WISRecognizeResult %s>" % self.status.name
        else:
            return "<WISRecognizeResult %s %s[%.2f]>" % (
                self.status.name, self.recognition, self.score)
    # #############################################

    def __bool__(self):
        return self.status == WISJobStatus.succeeded
    # #############################################

    @classmethod
    def from_content(cls, content: dict):
        status      = WISJobStatus(content['status'])
        results     = content.get('results', {})
        identity_id = results.get('identity_id')
        score       = results.get('score')
        recognition = results.get('recognition')
        
        return cls(status, identity_id, score, recognition)
    # #############################################
