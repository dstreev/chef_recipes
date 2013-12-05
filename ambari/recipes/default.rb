#
# Cookbook Name:: ambari
# Recipe:: default
#
# Copyright 2013, Example Com
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

log "Ambari Remote Repo File: #{node['ambari']['remote_repo_file']}"

remote_file '/etc/yum.repos.d/ambari.repo' do
  source node['ambari']['remote_repo_file']
  mode '00644'
  action :create_if_missing
end

yum_package "pdsh" do
	action :install
	flush_cache [:before]
end

yum_package "ambari-server" do
  action :install
  flush_cache [:before]
end

# Setup the Local Repos
if node['ambari']['repo']['local_url'] then
	log "Configure Ambari for Local Repo #{node['ambari']['repo']['local_url']}"
	stacks = ["1.3.2","2.0.6"]
	stacks.each do |stack|
		template "/var/lib/ambari-server/resources/stacks/HDPLocal/#{stack}/repos/repoinfo.xml" do
  			source "repoinfo.xml.#{stack}.erb"
			owner "root"
			group "root"
		  	mode "0644"
			variables(
				:localRepoUrl => node['ambari']['repo']['local_url']
			)
		end	
	end
end


if node['ambari']['jdk']['alt'] then
	log " Ambari configured for alt JDK: #{node['ambari']['jdk']['home']}"
	
	bash "ambari-server_setup with_alt_JDK" do
		code "sudo ambari-server setup -j #{node['ambari']['jdk']['home']} -s"
	end
elsif
	bash "ambari-server_setup" do
		code "sudo ambari-server setup -s"
	end
end

bash "ambari-server_start" do
  code "sudo ambari-server start"
end
