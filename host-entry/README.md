# Description
Used to add extra host entries to the /etc/hosts file of the target server.

# Requirements
Need to supply a set of host entries in the following:


# Attributes

```

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

