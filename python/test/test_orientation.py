import time
from src import wis
# #############################################

# get a token to process tests
token           = wis.auth.login()
# prepare values for nominal tests
image_path      = 'data/inputs/orientation.jpeg'

def test_orientation_create_task():
    job_id = wis.orientation.create_task(token, image_path)
# #############################################

def test_orientation_bad_create_task():
    try:
        bad_token = wis.auth.Token('', 0.0, '')
        wis.orientation.create_task(bad_token, image_path)

    except wis.WISException as what:
        pass # Expected Exception
    except Exception as what:
        raise Exception('Bad Exception: (%s) %r' % (type(what), what))
    else:
        raise Exception('Exception Required')
# #############################################

def test_get_job_status():
    job_id = wis.orientation.create_task(token, image_path)
    for _ in range(10):
        time.sleep(1)
        result = wis.orientation.get_job_status(token, job_id)
        if result: break
    assert result, 'Succeeded Not Tested'
    assert result.label == wis.orientation.WISOrientation.counter_clockwise
# #############################################

def test_bad_get_job_status():
    try:
        wis.orientation.get_job_status(token, 'BAD_JOB_ID')

    except wis.WISException as what:
        pass # Expected Exception
    except Exception as what:
        raise Exception('Bad Exception: (%s) %r' % (type(what), what))
    else:
        raise Exception('Exception Required')
# #############################################

