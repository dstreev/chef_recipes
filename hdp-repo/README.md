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
```
curl -L https://www.opscode.com/chef/install.sh | sudo bash
echo 'export PATH="/opt/chef/embedded/bin:$PATH"' >> ~/.bash_profile && source ~/.bash_profile
```
2. Install git
  1. yum install git
3. Install the Chef Librarian.  This step will allow us to build and us a local Chef-repo for the yum repo buildout. Detail here: https://github.com/applicationsonline/librarian-chef
```
gem install librarian-chef
```
#### Step #3: Control Files
Next we need to build a few control files that will help our system find the bit and pieces needed to build out the system.

Pick a root directory, it's location isn't important, as long as we are consistent from this point on:
```
mkdir hdp_repo_init
cd hdp_repo_init
```

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

log_level        :info
log_location     STDOUT
ssl_verify_mode  :verify_none
```

Create a file called 'solo.json'. This controls what 'recipes' and 'configurable attributes' we will be using.  Place the following contents in it: (Note: REPLACE 'repo fqdn' with the repo hosts FQDN)

solo.json
```
{
    "name": "HDP-Repo",
    "chef_type": "role",
    "description": "This is the base role for an HDP Repo Buildout",
    "default_attributes": {
        "hdp_repo": {
            "repo_host": "<repo fqdn>"
        },
        "apache": {
            "default_site_enabled": true
        }
    },
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
This process will take some time.  If you can run it over night, you'll be better off.  It will download as much as 30GB, so depending on your connection, you could be waiting for awhile.

Because it does attach and download many libraries, it has a tendency to timeout/fail during the buildout process. It is OK to run the command below several times, until the entire repo buildout completes successfully. The repo buildout is designed to be restartable and when run again it will:

1. Complete what wasn't completed before
2. Update the repos with the most current versions found on the mirrors.
```
chef-solo -c solo.rb -j solo.json
```

You can review the actual process used to buildout and create the local repository that you'll point to from Ambari (1.4.2 and above).



