from enum import Enum
# #############################################

class WISJobStatus(str, Enum):
    sent        = 'Sent'
    started     = 'Started'
    succeeded   = 'Succeeded'
    failed      = 'Failed'
    retried     = 'Retried'
    revoked     = 'Revoked'
# #############################################
