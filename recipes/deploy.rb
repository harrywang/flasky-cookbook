app = search(:aws_opsworks_app).first

# remove the code folder if exists
directory node['flasky-cookbook']['app_dir'] do
  recursive true
  action :delete
  only_if { ::File.directory?("#{node['flasky-cookbook']['app_dir']}") }
end

# Get the app code from Github
execute "get flasky code" do
    user "root"
    cwd node['flasky-cookbook']['project_root']
    command "git clone #{app['app_source']['url']}"
end

execute "install flasky requirements" do
    user "root"
    cwd node['flasky-cookbook']['app_dir']
    command "pip install -r requirements/dev.txt"
end

execute "setup flasky database" do
    user "root"
    cwd node['flasky-cookbook']['app_dir']
    command "python manage.py deploy"
end

execute "change sqlite database parent folder permission" do
    user "root"
    command "chown #{node['flasky-cookbook']['gunicorn_user']}:#{node['flasky-cookbook']['nginx_group']} #{node['flasky-cookbook']['app_dir']}"
end

execute "change sqlite database permission" do
    user "root"
    command "chown #{node['flasky-cookbook']['gunicorn_user']}:#{node['flasky-cookbook']['nginx_group']} #{node['flasky-cookbook']['app_dir']}/data-dev.sqlite"
end

service "flasky" do
  provider Chef::Provider::Service::Upstart
  supports :status => true
  action [:restart]
end

service "nginx" do
  action :restart
end
