import time
import os
# #############################################
from src import wis
# #############################################

# get a token to process tests
token = wis.auth.login()
# prepare values for nominal tests
media_path                  = 'data/inputs/watermark/input_media.jpeg'
watermark_path              = 'data/inputs/watermark/input_watermark.jpeg'
watermark_transparency      = 0.2
watermark_ratio             = 0.2
watermark_position_preset   = wis.watermark.WISWatermarkPositionPreset.upper_right
output_folder               = './data/outputs'

def test_anonymization_create_task():
    job_id = wis.watermark.create_task(token, media_path, watermark_path, 
        watermark_transparency, watermark_ratio, watermark_position_preset)
# #############################################

def test_anonymization_bad_create_task():
    try:
        job_id = wis.watermark.create_task(token, media_path, watermark_path, 
            'WRONG', watermark_ratio, watermark_position_preset)

    except wis.WISException as what:
        pass # Expected Exception
    except Exception as what:
        raise Exception('Bad Exception: (%s) %r' % (type(what), what))
    else:
        raise Exception('Exception Required')
# #############################################

def test_get_job_status_n_result():
    # create job
    job_id = wis.watermark.create_task(token, media_path, watermark_path, 
        watermark_transparency, watermark_ratio, watermark_position_preset)
        
    # get status until result is available
    for _ in range(10):
        time.sleep(1)
        result = wis.watermark.get_job_status(token, job_id)
        if result: break
    assert result, 'Succeeded Not Tested'

    # try to download as files
    # media -> Binary file
    path = wis.service.download_result_file(token, result.output_media, output_folder)
    assert os.path.exists(path)
    # try to download in-memory & check result type
    content = wis.service.get_result_file(token, result.output_media)
    assert isinstance(content, bytes)
# #############################################

