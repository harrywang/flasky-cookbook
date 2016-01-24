I am trying to make flasky (https://github.com/miguelgrinberg/flasky) work with AWS OpsWorks by following the tutorials below:
https://www.digitalocean.com/community/tutorials/how-to-set-up-uwsgi-and-nginx-to-serve-python-apps-on-ubuntu-14-04#definitions-and-concepts
http://kronosapiens.github.io/blog/2015/11/10/opsworks-flask-and-chef.html
Lots of code in this repo is based on the following one:
https://github.com/kronosapiens/chef-repo

1. `kitchen init`, edit .kitchen.yml to remove `- name: centos-7.1`
2. add metadata.rb, `name 'flasky-cookbook'` specify the cookbook's name, which is used in .kitchen.yml     `run_list: - recipe[flasky-cookbook::configure]`
3. add external cookbook in metatdata.rb `depends 'apt', '~> 2.9.2'` and add Berksfile
4. create configure.rb and include one line `include_recipe 'apt::default'`
5. run `kitchen converge` (no need to run `berks install`, somehow all external cookbook, i.e. apt cookbook, is automatically downloaded into ~/.berksfile/cookbooks)
6. install python-pip python-dev nginx by adding packages in configure.rb
7. create app directories, add attributes in attributes/default.rb
`default['flasky-cookbook']['project_dir'] = '/srv/www/flasky/'`
`default['flasky-cookbook']['config_dir'] = '/etc/flasky/'`
and add code in configure.rb to create those folders (make sure the attributes match the node[] code, otherwise there will be errors when trying to converge)
