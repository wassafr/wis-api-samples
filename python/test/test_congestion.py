import time
from src import wis
# #############################################

# get a token to process tests
token           = wis.auth.login()
# prepare values for nominal tests
image_path      = 'data/inputs/congestion.jpeg'
congestion_line = [dict(x=0.5, y=0.1), dict(x=0.5, y=0.9)]
included_area   = dict(left=0.1, right=0.9, top=0.1, bottom=0.9)

def test_congestion_create_task():
    # without 'included_area'
    job_id = wis.congestion.create_task(token, image_path, congestion_line)
    # with 'included_area'
    job_id = wis.congestion.create_task(token, image_path, congestion_line, included_area)
# #############################################

def test_congestion_bad_create_task():
    try:
        wis.congestion.create_task(token, image_path, None)

    except wis.WISException as what:
        pass # Expected Exception
    except Exception as what:
        raise Exception('Bad Exception: (%s) %r' % (type(what), what))
    else:
        raise Exception('Exception Required')
# #############################################

def test_get_job_status():
    job_id = wis.congestion.create_task(token, image_path, congestion_line, included_area)
    for _ in range(10):
        time.sleep(1)
        result = wis.congestion.get_job_status(token, job_id)
        if result: break
    assert result, 'Succeeded Not Tested'
# #############################################

def test_bad_get_job_status():
    try:
        wis.congestion.get_job_status(token, 'BAD_JOB_ID')

    except wis.WISException as what:
        pass # Expected Exception
    except Exception as what:
        raise Exception('Bad Exception: (%s) %r' % (type(what), what))
    else:
        raise Exception('Exception Required')
# #############################################

