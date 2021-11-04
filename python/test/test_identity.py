from src import wis
import time
# #############################################

# get a token to process tests
token           = wis.auth.login()
# prepare values for nominal tests
model_path      = 'data/inputs/identity1.jpeg'
test_ok_path    = 'data/inputs/identity2.jpeg'
test_ko_path    = 'data/inputs/anonymization.jpeg'


def test_nominal():
    # create a new identity creation task
    job_id = wis.identity.create_new_identity_task(token, [model_path])
    # wait for identity to be ready
    for _ in range(10):
        time.sleep(1)
        result = wis.identity.get_job_status(token, job_id)
        if result: break
    assert result, 'Identity not created properly (test timeout)'
    print('Identity created')

    # create an identity update task
    job_id = wis.identity.create_update_identity_task(token, result.identity_id, [model_path])
    # wait for identity to be updated
    for _ in range(10):
        time.sleep(1)
        result = wis.identity.get_job_status(token, job_id)
        if result: break
    assert result, 'Identity not updated properly (test timeout)'
    print('Identity updated')
    identity_id = result.identity_id

    # create a positive match job
    job_id = wis.identity.recognize.create_task(token, identity_id, test_ok_path)
    # wait for recognition to be done
    for _ in range(10):
        time.sleep(1)
        result = wis.identity.recognize.get_job_status(token, job_id)
        if result: break
    assert result, 'Recognize job not done properly (test timeout)'
    print(result)
    assert result.recognition, 'Expected recognition=True'

    # create a negative match job
    job_id = wis.identity.recognize.create_task(token, identity_id, test_ko_path)
    # wait for recognition to be done
    for _ in range(10):
        time.sleep(1)
        result = wis.identity.recognize.get_job_status(token, job_id)
        if result: break
    assert result, 'Recognize job not done properly (test timeout)'
    print(result)
    assert not result.recognition, 'Expected recognition=False'

    # create positive search job
    job_id = wis.identity.search.create_task(token, test_ok_path)
    # wait for recognition to be done
    for _ in range(10):
        time.sleep(1)
        result = wis.identity.search.get_job_status(token, job_id)
        if result: break
    assert result, 'Search job not done properly (test timeout)'
    print(result)
    assert len(result.identities), 'No identity found'

    # delete the identity
    job_id = wis.identity.delete_identities(token, [identity_id])
    print('Identity deleted')

    # try to delete identity already deleted
    # expect an exception
    try:
        job_id = wis.identity.delete_identities(token, [identity_id])
    except wis.WISException as what:
        print('Expected exception:', what)
    except Exception as what:
        raise Exception('Bad Exception: (%s) %r' % (type(what), what))
    else:
        raise Exception('Exception Required')
# #############################################
