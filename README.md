This is a cookbook I developed to make Flasky (https://github.com/miguelgrinberg/flasky) work with Chef local Test Kitchen and AWS OpsWorks.

I first made a cookbook for the following tutorial: https://www.digitalocean.com/community/tutorials/how-to-serve-flask-applications-with-gunicorn-and-nginx-on-ubuntu-14-04 - you can find the basic steps and how to avoid some pitfalls I ran into in the README at: https://github.com/harrywang/flask-gunicorn-nginx - my following note is based on this.

I then read the following tutorial:  http://kronosapiens.github.io/blog/2015/11/10/opsworks-flask-and-chef.html and revise the code in the following repo: https://github.com/kronosapiens/chef-repo to make this cookbook (I am using Gunicorn to be consistent with Flasky book while the tutorial uses uWSGI) - Many thanks to @kronosapiens

I was completely new to Chef and OpsWorks about 10 days before writing this cookbook - so I try to document the key steps in detail, every error I ran into and how I addressed them below (if you find errors and/or have better ways of doing things - please let me know)

Note to make Flasky working locally with Chef Test Kitchen:

0. Setup the basics (https://github.com/harrywang/flask-gunicorn-nginx)

1. Get flasky code from github and set it up using root (I am not sure whether this is the right way of doing this - I had to use sudo to run those commands) - NOTE that the commands cannot be put in one execute block - separate them into different blocks to make sure the previous commands must be completed before running the next one.

2. Given the way flasky is configured, the gunicorn start command needs to be changed to `chdir <%= node['flasky-cookbook']['app_dir'] %>
exec gunicorn --workers 3 --bind unix:<%= node['flasky-cookbook']['gunicorn_socket'] %> -m 007 manage:app`,

3. Make sure to use double quote in command and resource names so that attribute variables can be used. Single quotes created problems.

4. Setup logging for gunicorn by adding `--log-file <%= node['flasky-cookbook']['gunicorn_logfile']%>`

5. Change sqlite database permission - we use vagrant:www_data to start gunicorn so that we need to assign vagrant:www_data to the database file and its parent folder (refer to this article for Unix permissions: http://kronosapiens.github.io/blog/2015/08/11/understanding-unix-permissions.html) - somehow I have to have two separate execute blocks otherwise only the second one is executed.

6. use env to add environment variables to gunicorn in the flasky-gunicorn.conf.erb file. These variables are only visible to the gunicorn process, you can use `ps -aux|grep gunicorn` to find the pid and check the variables using `cat /proc/{pid}/environ`, `printenv` won't show those variables.

Other useful notes:
- to see the changes at  http://127.0.0.1:8888 in local browser, the cache needs to be cleaned.
- to check upstart log: `cd /var/log/upstart/`
- you can login to test by using `curl http://127.0.0.1`
