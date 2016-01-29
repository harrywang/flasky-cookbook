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

6. use env to add environment variables to gunicorn in the flasky-gunicorn.conf.erb file. These variables are only visible to the gunicorn process, you can use `ps -aux|grep gunicorn` to find the pid and check the variables using `cat /proc/{pid}/environ`, `printenv` won't show those variables. Also make sure you use DOUBLE QUOTES for variable values - this took me more than a whole day to figure out - ouch!

    env MAIL_SERVER="email-smtp.us-east-1.amazonaws.com"
    env MAIL_USERNAME="yourusername"
    env MAIL_PASSWORD="yourpassword"
    env FLASKY_ADMIN="youremail@gmail.com"

7. Special note for AWS SES: you have to verify domains and emails for different regions separately AND the FLASKY_MAIL_SENDER has to be verified before you can use SES to send out emails.

8. when ready for OpsWorks, first change `default['flasky-cookbook']['gunicorn_user'] = 'ubuntu'`,then `berks package`, upload the tarball to S3 and apply to OpsWorks.

9. NOTE: If you set OpsWorks to use Elastic IP - then if you use EIP in your browser, the default Nginx page will show up - DON'T KNOW WHY!! (my question on StackOverflow: http://stackoverflow.com/questions/35047766/nginx-does-not-serve-the-flask-pages-and-shows-the-default-static-page?noredirect=1#comment57854202_35047766) - you have to use the corresponding PUBLIC DNS to access for this to work.

10. Got to Flasky repo >> settings >> Add service and choose OpsWorks, go to AWS IAM, create a user, e.g., opsworks-flasky, give at least the following permissions:
```json
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "opsworks:CreateDeployment",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "opsworks:UpdateApp",
      "Resource": "*"
    }
  ]
}
```
Enter information for App, Stack, Branch name (master), access key, secret access key and add the service. Now, the code will be automatically deployed every time a new commit is pushed to master branch.

Other useful notes:
- to see the changes at  http://127.0.0.1:8888 in local browser, the cache needs to be cleaned.
- to check upstart log: `cd /var/log/upstart/`
- you can login to test by using `curl http://127.0.0.1`
