from enum import Enum
# #############################################

class WISOrientation(str, Enum):
    unknown             = 'unknown'
    normal              = 'normal'
    clockwise           = 'clockwise'
    counter_clockwise   = 'counter_clockwise'
    upside_down         = 'upside_down'
# #############################################
