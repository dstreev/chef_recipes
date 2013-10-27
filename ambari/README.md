# Description
Used to add extra host entries to the /etc/hosts file of the target server.

# Requirements
Need to supply a set of host entries in the following:


# Attributes

```
default['ambari']['remote_repo_file'] = 'http://public-repo-1.hortonworks.com/ambari/centos6/1.x/GA/ambari.repo'
default['ambari']['repo']['local'] = false
default['ambari']['repo']['local_url'] = 'undefined'

# Specify an alternate JDK.
default['ambari']['jdk']['alt'] = false
default['ambari']['jdk']['home'] = '/usr/lib/jvm/jdk1.7.0_45'
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
