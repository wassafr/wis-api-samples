from typing import List, Mapping
from collections import Counter
# #############################################
from ..wis_job_status import WISJobStatus
from .class_name import ClassName
# #############################################

class WISVehiclesPedestriansDetectionResult:
    def __init__(self, status: WISJobStatus, 
        object_counting: Mapping[ClassName, int]=None,
        objects: List[dict]=None):
        """
            'objects': [
                {
                    'class_name':   ClassName, 
                    'score':        float, 
                    'box':          [{'x': float, 'y': float}, ...]
                }
            ]
        """
        self.status             = status
        self.object_counting    = object_counting
        self.objects            = objects
    # #############################################

    def __repr__(self) -> str:
        if not self:
            return "<WISVehiclesPedestriansDetectionResult %s>" % self.status.name
        else:
            return "<WISVehiclesPedestriansDetectionResult %s #%d>" % ( 
                self.status.name, sum(self.object_counting))
    # #############################################

    def __bool__(self):
        return self.status == WISJobStatus.succeeded
    # #############################################

    @classmethod
    def from_content(cls, content: dict):
        status      = WISJobStatus(content['status'])
        if status == WISJobStatus.succeeded:
            object_counting = Counter({
                ClassName(k): v 
                for k, v 
                in content['object_counting'].items()
            })
            objects = [
                {
                    'class_name':   ClassName(obj['class_name']),
                    'score':        obj['score'],
                    'box':          obj['box']
                }
                for obj in content['objects']
            ]
        else:
            object_counting = None
            objects = None

        return cls(status, object_counting, objects)
    # #############################################
