from environs import Env
env = Env()
env.read_env()

wis_base_url            = env('WIS_BASE_URL', "https://api.services.wassa.io")
wis_service_base_url    = wis_base_url + "/innovation-service"

wis_client_id           = env('WIS_CLIENT_ID', None)
wis_secret_id           = env('WIS_SECRET_ID', None)
