from ..wis_job_status import WISJobStatus
# #############################################


class WISAnonymizationResult:
    def __init__(self, status: WISJobStatus, 
        output_media: str=None, output_json: str=None):

        self.status         = status        
        self.output_media   = output_media
        self.output_json    = output_json
    # #############################################

    def __repr__(self) -> str:
        return "<Anonymization %s>" % self.status.name
    # #############################################

    def __bool__(self):
        return self.status == WISJobStatus.succeeded
    # #############################################

    @classmethod
    def from_content(cls, content: dict):
        status      = WISJobStatus(content['status'])
        return cls(
            status,
            content.get('output_media'),
            content.get('output_json'),
        )
    # #############################################
