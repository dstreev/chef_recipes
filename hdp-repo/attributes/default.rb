# Repo Base Doc dir for HTTPD
default['hdp_repo']['base_repo']['dir'] = '/var/www/html/repos'
# Compressed Artifact Location
default['hdp_repo']['base_tgz']['dir'] = '/var/www/html/tgz'

default['hdp_repo']['location']['host'] = 'repo.changeme.com'

default['hdp_repo']['yum_repos']['local_dir'] = "#{node['hdp_repo']['base_repo']['dir']}/local.yum.repos.d"
default['hdp_repo']['artifacts']['dir'] = "#{node['hdp_repo']['base_repo']['dir']}/artifacts"

default['hdp_repo']['jdk']['bin'] = "#{node['hdp_repo']['artifacts']['dir']}/jdk-6u31-linux-x64.bin"
default['hdp_repo']['jdk']['source_bin'] = 'http://public-repo-1.hortonworks.com/ARTIFACTS/jdk-6u31-linux-x64.bin'

default['hdp_repo']['jdk7']['tgz'] = "#{node['hdp_repo']['artifacts']['dir']}/jdk-7u45-linux-x64.tar.gz"
default['hdp_repo']['jdk7']['source_tgz'] = 'http://public-repo-1.hortonworks.com/ARTIFACTS/jdk-7u45-linux-x64.tar.gz'

default['hdp_repo']['ext-2_2']['zip'] = "#{node['hdp_repo']['artifacts']['dir']}/ext-2.2.zip"
default['hdp_repo']['ext-2_2']['source'] = 'http://public-repo-1.hortonworks.com/ARTIFACTS/ext-2.2.zip'

default['hdp_repo']['mysql_connector']['zip'] = "#{node['hdp_repo']['artifacts']['dir']}/mysql-connector-java-5.1.18.zip"
default['hdp_repo']['mysql_connector']['source'] = 'http://public-repo-1.hortonworks.com/ARTIFACTS/mysql-connector-java-5.1.18.zip'

default['hdp_repo']['jce_policy-6']['zip'] = "#{node['hdp_repo']['artifacts']['dir']}/jce_policy-6.zip"
default['hdp_repo']['jce_policy-6']['source'] = 'http://public-repo-1.hortonworks.com/ARTIFACTS/jce_policy-6.zip'

default['hdp_repo']['jce_policy-7']['zip'] = "#{node['hdp_repo']['artifacts']['dir']}/UnlimitedJCEPolicyJDK7.zip"
default['hdp_repo']['jce_policy-7']['source'] = 'http://public-repo-1.hortonworks.com/ARTIFACTS/UnlimitedJCEPolicyJDK7.zip'

# Location of the "fixed" ambari.repo file that will contain references to the repo being built
default['hdp_repo']['yum_repos']['ambari'] = "#{node['hdp_repo']['yum_repos']['local_dir']}/ambari.repo"

default['hdp_repo']['os_base']['items'] = ["centos6"]

# The default version used for building the repo file.
default['hdp_repo']['ambari']['default_version'] = "1.5.1"
# The default version user for building the repo file.
default['hdp_repo']['hdp_utils']['default_version'] = "1.1.0.17"

default['hdp_repo']['repo']['public_url'] = "http://s3.amazonaws.com/public-repo-1.hortonworks.com"

