from src import wis
# #############################################


def test_login():
    token = wis.auth.login()
# #############################################

def test_bad_login():
    try:
        token = wis.auth.login('bad_client_id', 'bad_secret_id')    

    except wis.WISException as what:
        pass # Expected Exception
    except Exception as what:
        raise Exception('Bad Exception: (%s) %r' % (type(what), what))
    else:
        raise Exception('Exception Required')
# #############################################

def test_refresh_token():
    token = wis.auth.login()
    token = wis.auth.refresh_token(token)
# #############################################

def test_bad_refresh_token():
    try:
        token = wis.auth.Token('', 0, '')
        token = wis.auth.refresh_token(token)

    except wis.WISException as what:
        pass # Expected Exception
    except Exception as what:
        raise Exception('Bad Exception: (%s) %r' % (type(what), what))
    else:
        raise Exception('Exception Required')
# #############################################

def test_logout():
    token = wis.auth.login()
    wis.auth.logout(token)
# #############################################

def test_bad_logout():
    try:
        token = wis.auth.Token('', 0, '')
        wis.auth.logout(token)
    
    except wis.WISException as what:
        pass # Expected Exception
    except Exception as what:
        raise Exception('Bad Exception: (%s) %r' % (type(what), what))
    else:
        raise Exception('Exception Required')
# #############################################
