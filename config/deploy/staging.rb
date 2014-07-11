#############################################################
#  Application
#############################################################

set :deploy_to, "/web/portal"
set :branch, "staging"

#############################################################
#  Servers
#############################################################

set :domain, "smartgraphs-authoring.staging.concord.org"
server domain, :app, :web
role :db, domain, :primary => true
