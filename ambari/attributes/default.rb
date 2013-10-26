# Override this to point to an Ambari Repo file.
# The default will go to the internet.  To use a 
# local repo, change this to a repo file the is configured
# for a local repo installation.
default['ambari']['remote_repo_file'] = 'http://public-repo-1.hortonworks.com/ambari/centos6/1.x/GA/ambari.repo'

# Options are hdp_1.3.2, hdp_2.0-BETA, hdp_2.0
default['ambari']['localrepo']['version'] = 'hdp_1.3.2'
