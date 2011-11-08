## getting started ##
1. checkout the project from github
2. install [node][] for your platform. Try [homebrew][] on osx, then
   'brew install node'
3. install smartgraphs-generator using 'npm install' from this
   directory.
4. setup rvm in the usual way
    echo 'rvm use 1.9.2@smartgraphs --create' > .rvmrc; cd ..; cd -
5. run bundle install --binstubs
6. copy the database.sample.yml
    cp config/database.sample.yml config/database.yml
7. migrate the database
    bin/rake db:migrate
6. start up the server 'rails s'

### Notes ###
You might need to update your npm version before step 6 works.
You can try
    npm -g update npm
but that might fail, so then you can also try
    curl http://npmjs.org/install.sh | sudo sh

To learn about Hobo, check out the pdf "Rapid Rails 3 with Hobo" at http://hobocentral.net/books/

## update SmartGraphs runtime ##

1. checkout Smartgraphs repository
2. follow steps in Smartgraphs/readme
3. inside of the Smartgraphs folder
    rm -r tmp/build/static
    bundle exec sc-build smartgraphs -r --languages=en
    cp -r tmp/build/static ../smartgraphs-authoring/public
4. You might want check the existing files in the public folder and decide if they should be replaced
   or kept. Currently after doing this you can run SmartGraphs going going to:
/static/smartgraphs/en/82b404e9816653aae3437852c272301c88eb986a/index.html
5. you'll need to update the activities_controller and json_activities_controller to point to the new
   location of the index.html

## configuring & installing on a VM ##

* get setup with git and rvm
* follow the most of the instructions for [provisioning a vm at cc][]
* configure the new node using the chef web interface (copy and paste
  json below?)
  * use the 'cc_rails_app::simple_rails_app' recipe, and the 'node::default' recipe.
  * set apache::listen_ports to include 80 & 8080.
  * set cc_rails_app::portal::source_url to be git://github.com/concord-consortium/smartgraphs-authoring.git
  * set cc_rails_app::portal::source_branch to be master

## post chef steps ##
* currently database settings (config/database.yml) and mailer
  settings (config/mailer.yml) will not be configured when using
  the simple_rails_app recipe. You will need to manually edit them.
* if you want to serve on any port other than 80, you will have to edit your /etc/httpd/sites-enabled/<sitename>.conf file.

### chef configuration json (sample) ###
You should be able to paste this into your clean chef node.
change <VM_NAME> and change <SECRET>

    { "apache" : {
        "listen_ports" : [ "80", "8080"]
      },
      "cc_rails_app" : { "checkout" : true,
          "portal" : { "capistrano_folders" : true,
              "host_name" : "<VM_NAME>.concord.org",
              "mysql" : { "database" : "sg_authoring_prod",
                  "host" : "seymour.concord.org",
                  "password" : "<SECRET>",
                  "username" : "sg_authoring"
                },
              "root" : "/web/portal",
              "source_branch" : "master",
              "source_url" : "git://github.com/concord-consortium/smartgraphs-authoring.git",
              "theme" : "smartgraphs"
            },
          "user" : "deploy"
        },
      "rails" : { "environment" : "production" }
    }

### knife bootrap command ###
  knife bootstrap some.server.com -N node-name-from-previous-step -x your_ssh_username --distro centos5-cc --sudo -r "recipe[cc_rails_app::simple_rails_app]","recipe[node::default]" --bootstrap-version 0.9.16

### server info ###
ruby-vm8.concord.org  proxied through seymour as sg-authoring.staging.concord.org

[provisioning a vm at cc]:http://confluence.concord.org/display/TSC/Provisioning+a+new+virtual+server+via+VMWare+and+Chef?focusedCommentId=4128819#comment-4128819)
[node]:http://nodejs.org/
[homebrew]:http://mxcl.github.com/homebrew/
