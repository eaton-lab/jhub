
## configuration settings
c = get_config()

## Configure SSL -----------------------------------------------
c.JupyterHub.ssl_key = "/srv/jupyterhub/ssl/jhub.privkey.pem"
c.JupyterHub.ssl_cert = "/srv/jupyterhub/ssl/jhub.fullchain.pem"
c.JupyterHub.ip = '128.59.232.200'
c.JupyterHub.port = 443

## Configure OAuth ----------------------------------------------
c.JupyterHub.authenticator_class = 'oauthenticator.GitHubOAuthenticator'
c.Authenticator.oauth_callback_url = 'https://jhub.eaton-lab.org/hub/oauth_callback'
c.Authenticator.client_id = 'fee71ad7b23fe4daa861'
c.Authenticator.client_secret = '...'

## any members of these GH organization are whitelisted
c.Authenticator.admin_users = {"eaton-lab", "isaacovercast"}
c.Authenticator.whitelist = {
    "dereneaton",
    "eaton-lab",
    "isaacovercast",
    "pdsb-test-student",
    "pmckenz1",
    }

# Mount the real user's Docker volume on the host to the notebook user's
c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'
c.DockerSpawner.notebook_dir = '/home/jovyan/'
c.DockerSpawner.image = 'dereneaton/jhub'
c.DockerSpawner.volumes = {
    # user's persistent volume
    'jhub-user-{username}': '/home/jovyan/work',

    # admin's r/o pre-made data dir
    'data': {
        'bind': '/home/jovyan/data',
        'mode': 'ro',
        },
    }
c.DockerSpawner.remove_containers = True
c.DockerSpawner.mem_limit = '16G'

# set docker containers need to find the hub IP
c.JupyterHub.hub_ip = c.JupyterHub.ip

# max days to stay connected
c.JupyterHub.cookie_max_age_days = 5

# max number of users
c.JupyterHub.active_server_limit = 40
