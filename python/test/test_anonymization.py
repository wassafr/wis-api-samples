import time
import os
# #############################################
from src import wis
# #############################################

# get a token to process tests
token           = wis.auth.login()
# prepare values for nominal tests
image_path      = 'data/inputs/anonymization.jpeg'
included_area   = dict(left=0.1, right=0.9, top=0.1, bottom=0.9)
output_folder   = './data/outputs'

def test_anonymization_create_task():
    job_id = wis.anonymization.create_task(token, image_path, True, True, True, included_area)
# #############################################

def test_anonymization_bad_create_task():
    try:
        wis.anonymization.create_task(token, image_path, included_area='BAD_AREA')

    except wis.WISException as what:
        pass # Expected Exception
    except Exception as what:
        raise Exception('Bad Exception: (%s) %r' % (type(what), what))
    else:
        raise Exception('Exception Required')
# #############################################

def test_get_job_status_n_result():
    # create job
    job_id = wis.anonymization.create_task(token, image_path, True, True, True, included_area)

    # get status until result is available
    for _ in range(10):
        time.sleep(1)
        result = wis.anonymization.get_job_status(token, job_id)
        if result: break
    assert result, 'Succeeded Not Tested'

    # try to download as files
    # media -> Binary file
    path = wis.service.download_result_file(token, result.output_media, output_folder)
    assert os.path.exists(path)
    # json -> Text file
    path = wis.service.download_result_file(token, result.output_json, output_folder)
    assert os.path.exists(path)

    # try to download in-memory & check result type
    content = wis.service.get_result_file(token, result.output_media)
    assert isinstance(content, bytes)
    content = wis.service.get_result_file(token, result.output_json)
    assert isinstance(content, str)
# #############################################
