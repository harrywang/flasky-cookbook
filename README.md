I am trying to make flasky (https://github.com/miguelgrinberg/flasky) work with AWS OpsWorks by following the tutorials below:

1. https://www.digitalocean.com/community/tutorials/how-to-serve-flask-applications-with-gunicorn-and-nginx-on-ubuntu-14-04
2. http://kronosapiens.github.io/blog/2015/11/10/opsworks-flask-and-chef.html

Lots of code in this repo is based on the following one:
https://github.com/kronosapiens/chef-repo

For the basic setup for the first tutorial, see README at (lots of useful information) https://github.com/harrywang/flask-gunicorn-nginx

Note to make Flasky working locally:

1. get flasky code from github and set it up using root (I am not sure whether this is the right way of doing this - I had to use sudo to run those commands) - NOTE that the commands cannot be put in one execute block - separate them into different blocks to make sure the previous commands must be completed before running the next one.

2. given the way flasky is configured, the gunicorn start command needs to be changed to `chdir <%= node['flasky-cookbook']['app_dir'] %>
exec gunicorn --workers 3 --bind unix:<%= node['flasky-cookbook']['gunicorn_socket'] %> -m 007 manage:app`,

3. make sure to use double quote in command and resource names so that attribute variables can be used. Single quotes created problems.

4. setup logging for gunicorn by adding `--log-file <%= node['flasky-cookbook']['gunicorn_logfile']%>`

5. change sqlite database permission - we use vagrant:www_data to start gunicorn so that we need to assign vagrant:www_data to the database file and its parent folder (refer to this article for Unix permissions: http://kronosapiens.github.io/blog/2015/08/11/understanding-unix-permissions.html) - somehow I have to have two separate execute blocks otherwise only the second one is executed.

6. add environment variables by adding `environments_path: test/environments` in .kitchen.yml and use `printenv` to check


Other useful notes:
- to see the changes at  http://127.0.0.1:8888 in local browser, the cache needs to be cleaned.
- to check upstart log: `cd /var/log/upstart/`
- you can login to test by using `curl http://127.0.0.1`
