#############################################################
#  Connection:
#############################################################
set :gateway, "seymour.concord.org"

#############################################################
#  Application
#############################################################

set :deploy_to, "/web/portal"
set :branch, "production"

#############################################################
#  Servers
#############################################################

set :domain, "ruby-vm10.concord.org"
server domain, :app, :web
role :db, domain, :primary => true
