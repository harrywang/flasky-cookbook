include_recipe 'apt::default'
#
#package 'build-essential'
#package 'git'
#
package 'python-pip'
package 'python-dev'
package 'curl' # no need in production
# package 'python-numpy'
#
# package 'libncurses5-dev'
# package 'libpq-dev'
#
package 'nginx'
# package 'supervisor'
# package 'postgresql-client'

# create app directories
directory node['flasky-cookbook']['project_dir'] do
  recursive true
end

# directory node['flasky-cookbook']['config_dir'] do
#   recursive true
# end

# install gunicorn and flask - this will move to pip install requirements
execute 'install packages' do
    command 'pip install gunicorn flask'
end

# install an application file - note: file name cannot contain hyphen
template "#{node['flasky-cookbook']['project_dir']}/myapp.py" do
  source "myapp.erb"
end

template "#{node['flasky-cookbook']['project_dir']}/wsgi.py" do
  source "wsgi.erb"
end

template "/etc/init/myapp.conf" do
   source 'flasky-gunicorn.conf.erb'
end

template "/etc/nginx/sites-available/myapp" do
   source 'flasky-nginx.conf.erb'
end

link '/etc/nginx/sites-enabled/myapp' do
  to '/etc/nginx/sites-available/myapp'
end

# # copy config files
# template "/etc/nginx/sites-available/flasky" do
#    source 'flasky-nginx.erb'
# end
#
# link '/etc/nginx/sites-enabled/thena' do
#   to '/etc/nginx/sites-available/thena'
# end
#
# template "/etc/init/thena-uwsgi.conf" do
#    source 'thena-uwsgi.conf.erb'
# end
#
# template "#{node['thena-infra']['config_dir']}thena-uwsgi.ini" do
#    source 'thena-uwsgi.ini.erb'
# end
#
# template "#{node['thena-infra']['config_dir']}newrelic.ini" do
#    source 'newrelic.ini.erb'
# end
#
# # set up logging
# # nginx
# file node['thena-infra']['nginx_logfile'] do
#     mode '0644'
#     owner node['thena-infra']['nginx_user']
#     group node['thena-infra']['nginx_group']
# end
#
# file node['thena-infra']['nginx_errorfile'] do
#     mode '0644'
#     owner node['thena-infra']['nginx_user']
#     group node['thena-infra']['nginx_group']
# end
#
# # uwsgi
# directory node['thena-infra']['uwsgi_log_dir'] do
#   recursive true
# end
#
# file node['thena-infra']['uwsgi_logfile'] do
#     mode '0644'
#     owner node['thena-infra']['uwsgi_user']
#     group node['thena-infra']['uwsgi_group']
# end
#
# file node['thena-infra']['uwsgi_pidfile'] do
#     mode '0644'
#     owner node['thena-infra']['uwsgi_user']
#     group node['thena-infra']['uwsgi_group']
# end
#
# # start nginx
# # note: start as sudo, will spawn child processes w/ www-data owner
# service 'nginx' do
#   supports :status => true
#   action [:enable, :start]
# end
