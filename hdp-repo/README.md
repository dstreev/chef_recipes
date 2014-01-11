# Description
Build a Local Repo configured to support an HDP cluster installation.

# Requirements

# Default Attributes

```
# Repo Base Doc dir for HTTPD
default['hdp_repo']['base_repo']['dir'] = '/var/www/html/repos'
# Compressed Artifact Location
default['hdp_repo']['base_tgz']['dir'] = '/var/www/html/tgz'

default['hdp_repo']['location']['host'] = 'repo.changeme.com'

default['hdp_repo']['yum_repos']['local_dir'] = "#{node['hdp_repo']['base_repo']['dir']}/local.yum.repos.d"
default['hdp_repo']['artifacts']['dir'] = "#{node['hdp_repo']['base_repo']['dir']}/artifacts"

default['hdp_repo']['jdk']['bin'] = "#{node['hdp_repo']['artifacts']['dir']}/jdk-6u31-linux-x64.bin"
default['hdp_repo']['jdk']['source_bin'] = 'http://public-repo-1.hortonworks.com/ARTIFACTS/jdk-6u31-linux-x64.bin'

# Location of the "fixed" ambari.repo file that will contain references to the repo being built
default['hdp_repo']['yum_repos']['ambari'] = "#{node['hdp_repo']['yum_repos']['local_dir']}/ambari.repo"

default['hdp_repo']['os_base']['items'] = ["centos6"]

# The default version used for building the repo file.
default['hdp_repo']['ambari']['default_version'] = "1.4.3.38"
# The default version user for building the repo file.
default['hdp_repo']['hdp_utils']['default_version'] = "1.1.0.16"

default['hdp_repo']['repo']['public_url'] = "http://s3.amazonaws.com/public-repo-1.hortonworks.com"

```

# Usage

### Vagrant Chef (chef_solo)

See our [Vagrant Repo Buildout Shell](https://github.com/dstreev/vagrant/tree/master/hdp_repo)


### Standalone OS Provisioning with Chef-Solo

#### Step #1: OS Environment:
Build out a 'minimal' installation of the OS with network connectivity and access to the internet to pull down all the bits and pieces.  You won't need to do anything else beyond the basic installation and network configuration.

Make sure you establish a FQDN for the host, this will be used later in the process and also used to find the repo host during our HDP installation.

##### Assumptions:
1. All commands are run as 'root' or as a 'sudo' user.
2. Network connectivity
3. The OS has at least 35GB (should make it 50GB) of available disk space to complete the repository buildout.
4. Access to the Internet (at least during the time your building the repo)

#### Step #2: Additional Components to Install on the OS:
1. Chef-solo: Details can be found here: https://learnchef.opscode.com/quickstart/workstation-setup/#linux
  1. Short story, commands:

`curl -L https://www.opscode.com/chef/install.sh | sudo bash`
`echo 'export PATH="/opt/chef/embedded/bin:$PATH"' >> ~/.bash_profile && source ~/.bash_profile`

2. Install git
`yum install git`
3. Install the Chef Librarian.  This step will allow us to build and us a local Chef-repo for the yum repo buildout. Detail here: https://github.com/applicationsonline/librarian-chef
`gem install librarian-chef`

#### Step #3: Control Files
Next we need to build a few control files that will help our system find the bit and pieces needed to build out the system.

Pick a root directory, it's location isn't important, as long as we are consistent from this point on:
`mkdir hdp_repo_init`
`cd hdp_repo_init`

The assumption going forward is that all commands will be run from this newly created directory.

Create a file called 'Cheffile'. This tells the librarian-chef which 'recipes' to pull down and build out the chef local repository (different then our HDP repo) used for the provisioning process.  Place the following contents in it:

Cheffile
```
#!/usr/bin/env ruby
#^syntax detection

site 'http://community.opscode.com/api/v1'

cookbook 'apache2'
cookbook 'iptables'

cookbook 'hdp-repo', :git => 'https://github.com/dstreev/chef_recipes', :path => 'hdp-repo'
```

Create a file called 'solo.rb'.  This tells chef were to find it's cookbooks.  These are install, later, by the librarian-chef gems library we install above. Place the following contents in it:

solo.rb
```
root = File.absolute_path(File.dirname(__FILE__))

file_cache_path  root
cookbook_path    root + '/cookbooks'
role_path		 root + '/roles'

log_level        :info
log_location     STDOUT
ssl_verify_mode  :verify_none

```

Create a file called 'solo.json'. This controls what 'recipes' and 'roles' we will be using.

solo.json
```
{ "run_list": "role[local_repo]" }
```

Place the following contents for default_attributes.hdp_repo.location.host with the FQDN of the target Local Repo
your builging.

roles/local_repo.json
```
{
    "name": "local_repo",
    "default_attributes": {
        "hdp_repo": {
        	"os_base" : {
        		"items": ["centos6","suse11","ubuntu12"]
        	},
            "location": {
				"host": "repo.hwx.test"
	    	},
            "ambari": {
            	"default_version": "1.4.3.38",
                "versions": ["1.4.3.38","1.4.2.104"]
            },
            "hdp_utils": {
            	"default_version": "1.1.0.16",
                "versions": ["1.1.0.16"]
            },
            "hdp_1.3" : {
                "versions" : ["1.3.2.0","1.3.3.0","1.3.3.2"]
            },
            "hdp_2.0" : {
                "versions" : ["2.0.6.0","2.0.6.1","2.0.10.0"]
            }
        },
        "apache": {
            "default_site_enabled": true
        }
    },
    "json_class": "Chef::Role",
    "description": "This is the base role for an HDP Repo Buildout",
    "chef_type": "role",
    "run_list": [
        "recipe[hdp-repo]"
    ]
}

```

#### Step #4: Initialize the Chef Recipe Local Repository
Base on the settings in the 'Cheffile', we will bring down the required recipes needed for this installation.
```
librarian-chef install --verbose
```

Check back here for updates to the recipes and other various links. If we update the 'hdp-repo' recipe, it will not be picked up UNLESS you delete the 'Cheffile.lock' file. This file remember the SHA1 for the release pulled down during the initial fetch. Just delete the file and run the above command again the ensure you get the latest recipes.


#### Step #5: Build out our Local Repository
The buildout is separated into two pieces.  `chef-solo -c solo.rb -j solo.json` will pull-down only the HDP
 related repos, but will not buildout the base OS repos.

#### Command Summary
```
# HDP Repos
chef-solo -c solo.rb -j solo.json

```



