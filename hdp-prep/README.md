# Description
Prepare an OS for an HDP installation.

# Requirements
Prepare an OS for an HDP installation.  This recipe will do things like distribute a password-less ssh-key, disable selinux, turn-off iptables, install local repos (if desired), install jdk, and install ntp.

You will need the private ssh-key [here](templates/default/id_rsa) for your ambari installation and ssh passwordless access to the servers built with this recipe.

# Attributes

```
default['hdp-prep']['ssh']['user'] = 'root'
default['hdp-prep']['domain']['name'] = 'hortonworks.vagrant'

default['hdp-prep']['local-repo']['use'] = false
default['hdp-prep']['local-repo']['url'] = 'undefined'
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

