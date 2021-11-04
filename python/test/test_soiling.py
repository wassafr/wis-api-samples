import time
from src import wis
# #############################################

# get a token to process tests
token           = wis.auth.login()
# prepare values for nominal tests
image_path      = 'data/inputs/soiling.jpeg'
soiling_area    = [dict(x=0.0, y=1.0), dict(x=0.5, y=0.0), dict(x=1.0, y=1.0)]

def test_soiling_create_task():
    job_id = wis.soiling.create_task(token, image_path, soiling_area)
# #############################################

def test_soiling_bad_create_task():
    try:
        wis.soiling.create_task(token, image_path, None)

    except wis.WISException as what:
        pass # Expected Exception
    except Exception as what:
        raise Exception('Bad Exception: (%s) %r' % (type(what), what))
    else:
        raise Exception('Exception Required')
# #############################################

def test_get_job_status():
    job_id = wis.soiling.create_task(token, image_path, soiling_area)
    for _ in range(10):
        time.sleep(1)
        result = wis.soiling.get_job_status(token, job_id)
        if result: break
    assert result, 'Succeeded Not Tested'
# #############################################

def test_bad_get_job_status():
    try:
        wis.soiling.get_job_status(token, 'BAD_JOB_ID')

    except wis.WISException as what:
        pass # Expected Exception
    except Exception as what:
        raise Exception('Bad Exception: (%s) %r' % (type(what), what))
    else:
        raise Exception('Exception Required')
# #############################################

