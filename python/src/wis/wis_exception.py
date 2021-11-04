class WISException(Exception):
    def __init__(self, statusCode: int, error: str, message: str=None):
        self.status_code    = statusCode
        self.error          = error
        self.message        = message
    # #############################################

    def __repr__(self):
        if self.message is not None:
            return "<WISException (%d) %s : %s>" % (
                self.status_code, self.error, self.message)
        else:
            return "<WISException (%d) %s >" % (self.status_code, self.error)
    # #############################################

    def __str__(self):
        if self.message is not None:
            return self.message
        else:
            return "(%d) %s" % (self.status_code, self.error)
    # #############################################
    
    @classmethod
    def from_response(cls, response):
        try:
            return cls(**response.json())
        except:
            return cls(response.status_code, response.reason)
    # #############################################
