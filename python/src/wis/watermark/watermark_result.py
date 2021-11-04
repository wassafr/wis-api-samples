from ..wis_job_status import WISJobStatus
# #############################################


class WISWatermarkResult:
    def __init__(self, status: WISJobStatus, output_media: str=None):

        self.status         = status
        self.output_media   = output_media
    # #############################################

    def __repr__(self) -> str:
        return "<Watermark %s>" % self.status.name
    # #############################################

    def __bool__(self):
        return self.status == WISJobStatus.succeeded
    # #############################################

    @classmethod
    def from_content(cls, content: dict):
        status = WISJobStatus(content['status'])
        return cls(status, content.get('output_image_url'))
    # #############################################
