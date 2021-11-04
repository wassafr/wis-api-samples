from typing import List
# #############################################
from ..wis_job_status import WISJobStatus
# #############################################

class WISFacesAttributesResult:
    def __init__(self, status: WISJobStatus, faces: List[dict]):
        """
            faces: [
                {
                    'confidence': 1, 
                    'box': {'left': 0.205, 'top': 0.257, 'right': 0.818, 'bottom': 0.851}, 
                    'attributes': [
                        {'name': 'age', 'value': 29, 'confidence': 24.86}, 
                        {'name': 'gender', 'value': 'male', 'confidence': 1}, 
                        {'name': 'mask', 'value': 'no', 'confidence': 1}
                    ]
                }
            ]
        """

        self.status     = status
        self.faces      = faces
    # #############################################

    def __repr__(self) -> str:
        if not self:
            return "<WISOrientationResult %s>" % self.status.name
        else:
            return "<WISOrientationResult %s #%d>" % (self.status.name, len(self.faces))
    # #############################################

    def __bool__(self):
        return self.status == WISJobStatus.succeeded
    # #############################################

    def get(self, face_id: int, attribute_name: str):
        face      = self.faces[face_id]
        attribute = filter(lambda a: a['name'] == attribute_name, face['attributes'])
        return next(attribute)
    # #############################################

    @classmethod
    def from_content(cls, content: dict):
        status      = WISJobStatus(content['status'])
        faces       = content.get('faces')

        return cls(status, faces)
    # #############################################
