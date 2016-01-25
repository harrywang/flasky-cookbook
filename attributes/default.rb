# # general settings
# default['flasky-cookbook']['app_name'] = 'flasky'
default['flasky-cookbook']['project_root'] = '/srv/www/'
# default['flasky-cookbook']['project_dir'] = '/srv/www/flasky/'
default['flasky-cookbook']['app_dir'] = '/srv/www/flasky/' # AWS uses current
# default['flasky-cookbook']['config_dir'] = '/etc/flasky/' # Must update app if this changes

# nginx settings
default['flasky-cookbook']['server_port'] = '80'
# default['flasky-cookbook']['server_name'] = 'flasky.com'
default['flasky-cookbook']['server_name'] = '127.0.0.1' # Local chef development
default['flasky-cookbook']['nginx_logfile'] = '/var/log/nginx/access.log' # default
default['flasky-cookbook']['nginx_errorfile'] = '/var/log/nginx/error.log' # default
default['flasky-cookbook']['nginx_user'] = 'www-data' # default
default['flasky-cookbook']['nginx_group'] = 'www-data'
default['flasky-cookbook']['gunicorn_socket'] = '/tmp/flasky.sock'

# gunicorn settings
# default['flasky-cookbook']['gunicorn_user'] = 'ubuntu'
default['flasky-cookbook']['gunicorn_user'] = 'vagrant' # Local chef development
default['flasky-cookbook']['gunicorn_group'] = 'www-data'
default['flasky-cookbook']['gunicorn_log_dir'] = '/var/log/gunicorn/'
default['flasky-cookbook']['gunicorn_logfile'] = '/var/log/gunicorn/gunicorn.log'

# git settings
default['flasky-cookbook']['git_repo_uri'] = 'https://github.com/harrywang/flasky.git'
