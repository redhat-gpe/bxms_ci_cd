Prototype for ci/cd setup for JBoss BPMS

* bpms-design: user joe/joe. Roles=admin,analyst,user,kie-server,kiemgmt
* bpms-design: organizational unit 'acme'
* bpms-design: repository 'policyquote'
* local: repository 'policyquote' cloned from bpms.
* local: added .gitignore, set git user to joe@acme.org
* local: remote 'origin' renamed to 'bpms'
* gitlab: created user 'joe/redhat01'
* gitlab: uploaded ssh key 'id_rsa'
* gitlab: created group acme-insurance, member=joe
* local: added git remote for gitlab
+
----
$ git remote set-url origin ssh://git@localhost:10022/acme-insurance/policyquote.git
----
* jenkins: install plugin git-client, git, maven (update), workflow-aggregator
* gitlab: create project for workflow script
* nexus: add `http://download.devel.redhat.com/brewroot/repos/jb-bxms-6.2-build/latest/maven` repository
* nexus: added all repositories to public group
* jenkins image: configure git user settings
* gitlab: create user jenkins, add to group acme-insurance
* jenkins: create SSH key, added to Credentials plugin
* gitlab: uploaded jenkins SSH key
* note: bpms-runtime -> no support for quartz
* jenkins: when running script from git repo, sandboxed by default. Permissions must be set in http://172.17.1.128:8080/scriptApproval/
* gitlab: added webhook in policyquote project `http://172.17.1.151:8080/git/notifyCommit?url=ssh://git@gitlab/acme-insurance/policyquote.git`