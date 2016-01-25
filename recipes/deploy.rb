# include_recipe 'deploy::default'
# node[:deploy].each do |application, deploy|
#   opsworks_deploy_dir do
#     user deploy[:user]
#     group deploy[:group]
#     path deploy[:deploy_to]
#   end
#
#   opsworks_deploy do
#     deploy_data deploy
#     app application
#   end
# end

# Get flasky code from github
execute "get flasky code" do
    user "root"
    cwd node['flasky-cookbook']['project_root']
    command "git clone #{node['flasky-cookbook']['git_repo_uri']}"
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
    command "chown vagrant:www-data #{node['flasky-cookbook']['app_dir']}"
end

execute "change sqlite database permission" do
    user "root"
    command "chown vagrant:www-data #{node['flasky-cookbook']['app_dir']}/data-dev.sqlite"
end

service "flasky" do
  provider Chef::Provider::Service::Upstart
  supports :status => true
  action [:restart]
end

service "nginx" do
  action :restart
end
