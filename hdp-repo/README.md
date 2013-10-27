# Description
Build a Local Repo configured to support an HDP cluster installation.

# Requirements

# Attributes

```
default['hdp_repo']['base_repo_dir'] = '/var/www/html/repos'
default['hdp_repo']['local_yum_repos_dir'] = "#{node['hdp_repo']['base_repo_dir']}/local.yum.repos.d"
default['hdp_repo']['artifacts_dir'] = "#{node['hdp_repo']['base_repo_dir']}/artifacts"

default['hdp_repo']['jdk_bin'] = "#{node['hdp_repo']['artifacts_dir']}/jdk-6u31-linux-x64.bin"
default['hdp_repo']['jdk_source_bin'] = 'http://public-repo-1.hortonworks.com/ARTIFACTS/jdk-6u31-linux-x64.bin'

default['hdp_repo']['ambari_repo_d'] = "/etc/yum.repos.d/ambari.repo"
default['hdp_repo']['ambari_repo_artifact'] = "#{node['hdp_repo']['local_yum_repos_dir']}/ambari.repo"

default['hdp_repo']['ambari_repo_source'] = "http://public-repo-1.hortonworks.com/ambari/centos6/1.x/GA/ambari.repo"

default['hdp_repo']['hdp_repo']['1.x']['d'] = "/etc/yum.repos.d/hdp.repo"
default['hdp_repo']['hdp_repo']['1.x']['source'] = "http://public-repo-1.hortonworks.com/HDP/centos6/1.x/GA/hdp.repo"

default['hdp_repo']['hdp_repo']['2.x']['d'] = "/etc/yum.repos.d/hdp2.repo"
default['hdp_repo']['hdp_repo']['2.x']['source'] = "http://public-repo-1.hortonworks.com/HDP/centos6/2.x/GA/hdp.repo"

default['hdp_repo']['hdp_repo_d'] = "/etc/yum.repos.d/hdp.repo"
default['hdp_repo']['hdp_repo_artifact'] = "#{node['hdp_repo']['local_yum_repos_dir']}/hdp.repo"
default['hdp_repo']['hdp_repo_source'] = "http://public-repo-1.hortonworks.com/HDP/centos6/1.x/GA/hdp.repo"

default['hdp_repo']['repo_host'] = 'needs.to.be.overridden'
```

# Usage

### Vagrant Chef (chef_solo)

```
    chef.json = {
 	        "hostentries" => [
				{"ipaddress" => "192.168.90.1", "hostname" => "repo.hortonworks.vagrant"}
			]	
   		}
```

### As a Role Parameter

```
  "default_attributes": {
    "hostentries": [
      {"ipaddress":"192.168.90.1", "hostname":"repo.hortonworks.vagrant"},
      {"ipaddress":"192.168.90.9", "hostname":"local.hortonworks.vagrant"}
    ],	
  	...
 
```
