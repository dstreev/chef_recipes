#
# Cookbook Name:: ambari
# Recipe:: default
#
# Copyright 2013, David W. Streever
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

include_recipe "apache2"
include_recipe "iptables::disabled"

baseRepoDir = node['hdp_repo']['base_repo']['dir']
test1 = node['hdp_repo']['ambari']['version']
test2 = node['hdp_repo']['os_base']['item']

bash "yum-repolist" do
  code "yum repolist"
end

yum_package "yum-utils" do
  action :install
  flush_cache [:before]
end

yum_package "createrepo" do
  action :install
  flush_cache [:before]
end

# Directory to store pre-configured repos that point to the local repo host.
directory node['hdp_repo']['yum_repos']['local_dir'] do
  owner "root"
  group "root"
  recursive true
  mode 0755
  action :create
end

directory node['hdp_repo']['base_tgz']['dir'] do
  owner "root"
  group "root"
  recursive true
  mode 0755
  action :create
end


directory node['hdp_repo']['artifacts']['dir'] do
  owner "root"
  group "root"
  recursive true
  mode 0755
  action :create
end

remote_file node['hdp_repo']['jdk']['bin'] do
  source node['hdp_repo']['jdk']['source_bin']
  owner "root"
  owner "root"
  mode 0644
  action :create_if_missing
end

remote_file node['hdp_repo']['jdk7']['tgz'] do
  source node['hdp_repo']['jdk7']['source_tgz']
  owner "root"
  owner "root"
  mode 0644
  action :create_if_missing
end

remote_file node['hdp_repo']['ext-2_2']['zip'] do
  source node['hdp_repo']['ext-2_2']['source']
  owner "root"
  owner "root"
  mode 0644
  action :create_if_missing
end

remote_file node['hdp_repo']['mysql_connector']['zip'] do
  source node['hdp_repo']['mysql_connector']['source']
  owner "root"
  owner "root"
  mode 0644
  action :create_if_missing
end

remote_file node['hdp_repo']['jce_policy-6']['zip'] do
  source node['hdp_repo']['jce_policy-6']['source']
  owner "root"
  owner "root"
  mode 0644
  action :create_if_missing
end

remote_file node['hdp_repo']['jce_policy-7']['zip'] do
  source node['hdp_repo']['jce_policy-7']['source']
  owner "root"
  owner "root"
  mode 0644
  action :create_if_missing
end


template "#{node['hdp_repo']['yum_repos']['ambari']}" do
	source "ambari.repo.erb"
	owner "root"
	group "root"
  mode 0644
	variables({
		:localRepoHostRepo => "#{node['hdp_repo']['location']['host']}/repos",
    :ambariVersion => node['hdp_repo']['ambari']['default_version'],
    :hdpUtilsVersion => node['hdp_repo']['hdp_utils']['default_version']
  })
end


remote_file node['hdp_repo']['jdk']['bin'] do
  source node['hdp_repo']['jdk']['source_bin']
  mode 0644
  action :create_if_missing
end

directory "#{baseRepoDir}" do
  owner "root"
  group "root"
  mode 0755
  recursive true
  action :create
end

node['hdp_repo']['os_base']['items'].each do |os|

  # AMBARI
  node['hdp_repo']['ambari']['versions'].each do |version|

    ambariSourceFile = "ambari-#{version}-#{os}.tar.gz"

    # Download
    remote_file "#{node['hdp_repo']['base_tgz']['dir']}/#{ambariSourceFile}" do
      source "#{node['hdp_repo']['repo']['public_url']}/ambari/#{os}/#{ambariSourceFile}"
      mode 0644
      action :create_if_missing
    end

    # Extract
    bash 'extract_ambari' do
      cwd node['hdp_repo']['base_tgz']['dir']
      code <<-EOH
      if [ ! -d #{baseRepoDir}/ambari/#{os}/1.x/updates/#{version} ];
      then
        tar xzf #{ambariSourceFile} -C #{baseRepoDir}
      fi
      EOH
    end

  end

# HDP Utils
  node['hdp_repo']['hdp_utils']['versions'].each do |version|

    utilsSourceFile = "HDP-UTILS-#{version}-#{os}.tar.gz"
    #http://s3.amazonaws.com/public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.16/repos/centos6/HDP-UTILS-1.1.0.16-centos6.tar.gz
    # Download
    remote_file "#{node['hdp_repo']['base_tgz']['dir']}/#{utilsSourceFile}" do
      source "#{node['hdp_repo']['repo']['public_url']}/HDP-UTILS-#{version}/repos/#{os}/#{utilsSourceFile}"
      mode 0644
      action :create_if_missing
    end

    # Extract
    bash 'extract_HDP_UTILS' do
      cwd node['hdp_repo']['base_tgz']['dir']
      code <<-EOH
      if [ ! -d #{baseRepoDir}/HDP-UTILS-#{version}/repos/#{os} ];
      then
        tar xzf #{utilsSourceFile} -C #{baseRepoDir}
      fi
      EOH
    end

  end

  # HDP 1.3.x
  node['hdp_repo']['hdp_1.3']['versions'].each do |version|

    hdpSourceFile = "HDP-#{version}-#{os}-rpm.tar.gz"

    # Download
    remote_file "#{node['hdp_repo']['base_tgz']['dir']}/#{hdpSourceFile}" do
      source "#{node['hdp_repo']['repo']['public_url']}/HDP/#{os}/#{hdpSourceFile}"
      mode 0644
      action :create_if_missing
    end

    # Extract
    bash 'extract_HDP_1.3' do
      cwd node['hdp_repo']['base_tgz']['dir']
      code <<-EOH
      if [ ! -d #{baseRepoDir}/HDP/#{os}/1.x/updates/#{version} ];
      then
        tar xzf #{hdpSourceFile} -C #{baseRepoDir}
      fi
      EOH
    end

  end

  # HDP 2.0.x
  node['hdp_repo']['hdp_2.0']['versions'].each do |version|

    hdpSourceFile = "HDP-#{version}-#{os}-rpm.tar.gz"

    # Download
    remote_file "#{node['hdp_repo']['base_tgz']['dir']}/#{hdpSourceFile}" do
      source "#{node['hdp_repo']['repo']['public_url']}/HDP/#{os}/#{hdpSourceFile}"
      mode 0644
      action :create_if_missing
    end

    # Extract
    bash 'extract_HDP_2.0' do
      cwd node['hdp_repo']['base_tgz']['dir']
      code <<-EOH
      if [ ! -d #{baseRepoDir}/HDP/#{os}/2.x/updates/#{version} ];
      then
        tar xzf #{hdpSourceFile} -C #{baseRepoDir}
      fi
      EOH
    end

  end

  # HDP 2.1.x
  node['hdp_repo']['hdp_2.1']['versions'].each do |version|

	version['GA'].each do |ga|
	    hdpSourceFile = "HDP-#{version}-#{os}-rpm.tar.gz"

    	# Download
	    remote_file "#{node['hdp_repo']['base_tgz']['dir']}/#{hdpSourceFile}" do
    	  source "#{node['hdp_repo']['repo']['public_url']}/HDP/#{os}/#{hdpSourceFile}"
	      mode 0644
    	  action :create_if_missing
	    end

    	# Extract
	    bash 'extract_HDP_2.1_GA' do
	      cwd node['hdp_repo']['base_tgz']['dir']
	      code <<-EOH
	      if [ ! -d #{baseRepoDir}/HDP/#{os}/2.x/GA/#{version} ];
	      then
	        tar xzf #{hdpSourceFile} -C #{baseRepoDir}
	      fi
	      EOH
    	end
	end
	version['updates'].each do |ga|
	    hdpSourceFile = "HDP-#{version}-#{os}-rpm.tar.gz"

    	# Download
	    remote_file "#{node['hdp_repo']['base_tgz']['dir']}/#{hdpSourceFile}" do
    	  source "#{node['hdp_repo']['repo']['public_url']}/HDP/#{os}/#{hdpSourceFile}"
	      mode 0644
    	  action :create_if_missing
	    end

    	# Extract
	    bash 'extract_HDP_2.1_updates' do
	      cwd node['hdp_repo']['base_tgz']['dir']
	      code <<-EOH
	      if [ ! -d #{baseRepoDir}/HDP/#{os}/2.x/updates/#{version} ];
	      then
	        tar xzf #{hdpSourceFile} -C #{baseRepoDir}
	      fi
	      EOH
    	end
	end

  end

end



directory "#{baseRepoDir}/ambari/centos6/RPM-GPG-KEY" do
  owner "root"
  group "root"
  mode 0755
  recursive true
  action :create
end

remote_file "#{baseRepoDir}/ambari/centos6/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins" do
  source "http://public-repo-1.hortonworks.com/ambari/centos6/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins"
  mode 0644
  action :create_if_missing
end


