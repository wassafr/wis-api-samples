from datetime import timedelta

class Token:
    def __init__(self, token: str, expireTime: int, refreshToken: str):
        self.token          = token
        self.expire_time    = timedelta(seconds=expireTime)
        self.refresh_token  = refreshToken
    # #############################################

    def __repr__(self):
        return "<Token expire_time[%s]>" % self.expire_time
    # #############################################

    @property
    def header(self):
        return { 'Authorization': 'Bearer %s' % self.token }
    # #############################################
