import time
from collections import Counter
# #############################################
from src import wis
# #############################################

# get a token to process tests
token           = wis.auth.login()
# prepare values for nominal tests
image_path      = 'data/inputs/VAP.jpg'
class_names     = [wis.vehicles_pedestrians_detection.ClassName.car]
detection_area  = [
    dict(x=0.1, y=0.1),
    dict(x=0.9, y=0.1),
    dict(x=0.9, y=0.9),
    dict(x=0.1, y=0.9)
]

def test_vehicles_pedestrians_detection_create_task():
    # without parameters
    job_id = wis.vehicles_pedestrians_detection.create_task(token, image_path)
    # with parameters
    job_id = wis.vehicles_pedestrians_detection.create_task(token, image_path,
        class_names, detection_area)
# #############################################

def test_vehicles_pedestrians_detection_bad_create_task():
    try:
        bad_token = wis.auth.Token('', 0, '')
        wis.vehicles_pedestrians_detection.create_task(bad_token, image_path)

    except wis.WISException as what:
        pass # Expected Exception
    except Exception as what:
        raise Exception('Bad Exception: (%s) %r' % (type(what), what))
    else:
        raise Exception('Exception Required')
# #############################################

def test_get_job_status():
    job_id = wis.vehicles_pedestrians_detection.create_task(token, image_path,
        class_names, detection_area)
    for _ in range(10):
        time.sleep(1)
        result = wis.vehicles_pedestrians_detection.get_job_status(token, job_id)
        if result: break
    assert result, 'Succeeded Not Tested'
    print(result.object_counting)
# #############################################

def test_bad_get_job_status():
    try:
        wis.vehicles_pedestrians_detection.get_job_status(token, 'BAD_JOB_ID')

    except wis.WISException as what:
        pass # Expected Exception
    except Exception as what:
        raise Exception('Bad Exception: (%s) %r' % (type(what), what))
    else:
        raise Exception('Exception Required')
# #############################################

