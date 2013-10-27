#
# Cookbook Name:: host-entry
# Recipe:: default
#
# Copyright 2013, David Streever
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Doesn't work with current 0.5.6 selinux recipe, should work with
# 0.6.x but that recipe is broken for disabled. Once fixed, you should be
# able to use attributes to control this setting. Just add this to the 
# default_attributes of the role (of whatever):
# 
# 	"selinux": {
#   		"state": "disabled"
#   	}
# -----
# selinux_state "SELinux #{node['selinux']['state'].capitalize}" do
#   action node['selinux']['state'].downcase.to_sym
# end

# Working selinux 0.5.6 version.
include_recipe "selinux::disabled"

include_recipe "ntp"
include_recipe "iptables::disabled"
include_recipe "java"

# TODO: The keys when distributed for vagrant don't allow pdsh, because the vagrant private
#        key already exists.  Need to add the hdp private key to the vagrant (alt) user account
#        and configure an .ssh/config entry to use the alternate Identityfile for *.hortonworks.vagrant domains.

# Clean up the default localhost entry in /etc/hosts that mangled by the vm.hostname process in vagrant.
bash "cleanup-localhost" do
	code "sed -i -e 's:^127\.0\.0\.1.*:127\.0\.0.1\ localhost:g' /etc/hosts"
end

# Distribute ssh keys to 'root' and user (if different from root).
directory "/root/.ssh" do
	owner "root"
	group "root"
	mode 0700
	action :create
end

if node['hdp-prep']['ssh']['user'] != 'root' then 
	directory "/home/#{node['hdp-prep']['ssh']['user']}/.ssh" do
		owner node['hdp-prep']['ssh']['user']
		group node['hdp-prep']['ssh']['user']
		mode 0700
		action :create
	end
end

if node['hdp-prep']['local-repo']['use'] then
	log "Configuring for Local Repo"
	
	log "Deleting CentOS*.repo Files."
	file "/etc/yum.repos.d/CentOS-Base.repo" do
		action :delete
	end
	file "/etc/yum.repos.d/CentOS-Debuginfo.repo" do
		action :delete
	end
	file "/etc/yum.repos.d/CentOS-Media.repo" do
		action :delete
	end
	file "/etc/yum.repos.d/CentOS-Vault.repo" do
		action :delete
	end
	file "/etc/yum.repos.d/epel.repo" do
		action :delete
	end

	log "Restoring CentOS-Base.repo file with Local Repo References"
	template "/etc/yum.repos.d/CentOS-Base.repo" do
  		source "CentOS-Base.repo.erb"
		owner "root"
		group "root"
	  	mode "0644"
		variables(
			:repoBaseUrl => node['hdp-prep']['local-repo']['url']
		)
	end
	log "Restoring epel.repo file with Local Repo References"
	template "/etc/yum.repos.d/epel.repo" do
  		source "epel.repo.erb"
		owner "root"
		group "root"
	  	mode "0644"
		variables(
			:repoBaseUrl => node['hdp-prep']['local-repo']['url']
		)
	end
end

if node['hdp-prep']['ssh']['user'] != 'root' then 
	template "/home/#{node['hdp-prep']['ssh']['user']}/.ssh/config" do
  		source "ssh_config.erb"
		owner node['hdp-prep']['ssh']['user']
		group node['hdp-prep']['ssh']['user']
	  	mode "0600"
		variables(
			:domain => node['hdp-prep']['domain']['name']
		)
	end
end

# Private Key
template "/root/.ssh/id_rsa" do
  source "id_rsa"
  owner "root"
  group "root"
  mode "0600"
end
	
if node['hdp-prep']['ssh']['user'] != 'root' then 
	template "/home/#{node['hdp-prep']['ssh']['user']}/.ssh/id_hdp_rsa" do
	  source "id_rsa"
	  owner node['hdp-prep']['ssh']['user']
	  group node['hdp-prep']['ssh']['user']
	  mode "0600"
	end
end

# Public Key
template "/root/.ssh/id_rsa.pub" do
  source "id_rsa.pub"
  owner "root"
  group "root"
  mode "0600"
end

if node['hdp-prep']['ssh']['user'] != 'root' then 
	template "/home/#{node['hdp-prep']['ssh']['user']}/.ssh/id_hdp_rsa.pub" do
	  source "id_rsa.pub"
	  owner node['hdp-prep']['ssh']['user']
	  group node['hdp-prep']['ssh']['user']
	  mode "0600"
	end
end

# Account for home directory differences with 'root' and also
# check to ensure you don't overwrite an existing 'authorized_keys' file
# and that we don't write duplicate entries if the process is run again.
file "/root/.ssh/authorized_keys" do
	owner "root"
	group "root"
	mode "0600"
	action :create_if_missing
end

if !File.file?("/root/.ssh/chef_authorized_keys.do_not_delete") then
	template "/root/.ssh/chef_authorized_keys.do_not_delete" do
	  source "id_rsa.pub"
	  owner "root"
	  group "root"
	  mode "0600"
	end
			  
	bash "append-sshkey-for-vagrant" do
		code "cat /root/.ssh/chef_authorized_keys.do_not_delete >> /root/.ssh/authorized_keys"
	end
end 
	
if node['hdp-prep']['ssh']['user'] != 'root' then 
	file "/home/#{node['hdp-prep']['ssh']['user']}/.ssh/authorized_keys" do
		owner node['hdp-prep']['ssh']['user']
		group node['hdp-prep']['ssh']['user']
		mode "0600"
		action :create_if_missing
	end

	if !File.file?("/home/#{node['hdp-prep']['ssh']['user']}/.ssh/chef_authorized_keys.do_not_delete") then
		template "/home/#{node['hdp-prep']['ssh']['user']}/.ssh/chef_authorized_keys.do_not_delete" do
		  source "id_rsa.pub"
		  owner node['hdp-prep']['ssh']['user']
		  group node['hdp-prep']['ssh']['user']
		  mode "0600"
		end
			  
		bash "append-sshkey-for-vagrant" do
			code "cat /home/#{node['hdp-prep']['ssh']['user']}/.ssh/chef_authorized_keys.do_not_delete >> /home/#{node['hdp-prep']['ssh']['user']}/.ssh/authorized_keys"
		end
	end 
end
