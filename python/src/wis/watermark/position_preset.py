from enum import Enum
# #############################################

class WISWatermarkPositionPreset(str, Enum):
    upper_right     = 'upper_right'
    lower_right     = 'lower_right'
    upper_left      = 'upper_left'
    lower_left      = 'lower_left'
    center_right    = 'center_right'
    center_left     = 'center_left'
    center          = 'center'
    lower           = 'lower'
# #############################################
