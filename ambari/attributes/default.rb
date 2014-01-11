# Override this to point to an Ambari Repo file.
# The default will go to the internet.  To use a 
# local repo, change this to a repo file the is configured
# for a local repo installation.
default['ambari']['remote_repo_file'] = 'http://public-repo-1.hortonworks.com/ambari/centos6/1.x/GA/ambari.repo'
default['ambari']['repo']['local'] = false
default['ambari']['repo']['local_url'] = 'undefined'

# Specify an alternate JDK.
default['ambari']['jdk']['alt'] = false
default['ambari']['jdk']['home'] = '/usr/lib/jvm/jdk1.7.0_51'
