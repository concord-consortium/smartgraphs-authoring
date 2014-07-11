#############################################################
#  Application
#############################################################

set :deploy_to, "/web/portal"
set :branch, "production"

#############################################################
#  Servers
#############################################################

set :domain, "smartgraphs-authoring.concord.org"
server domain, :app, :web
role :db, domain, :primary => true
