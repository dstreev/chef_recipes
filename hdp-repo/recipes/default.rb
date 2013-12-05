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

include_recipe "apache2"
include_recipe "iptables::disabled"

localRepoHost = node['hdp_repo']['repo_host']
ambariRepoArtifact = node['hdp_repo']['ambari_repo_artifact']
baseRepoDir = node['hdp_repo']['base_repo_dir']
localyumDir = node['hdp_repo']['local_yum_repos_dir']


remote_file node['hdp_repo']['ambari_repo_d'] do
  source node['hdp_repo']['ambari_repo_source']
  mode '00644'
  action :create
end

# Get the hdp.repo for for 1.x and 2.x
remote_file node['hdp_repo']['hdp_repo']['1.x']['d'] do
  source node['hdp_repo']['hdp_repo']['1.x']['source']
  mode '00644'
  action :create
end
remote_file node['hdp_repo']['hdp_repo']['2.x']['d'] do
  source node['hdp_repo']['hdp_repo']['2.x']['source']
  mode '00644'
  action :create
end

bash "yum-repolist" do
	code "yum repolist"
end

#yum_package "epel-release" do
#	action :install
#	flush_cache [:before]
#end

yum_package "yum-utils" do
	action :install
	flush_cache [:before]
end

yum_package "createrepo" do
	action :install
	flush_cache [:before]
end

directory node['hdp_repo']['local_yum_repos_dir'] do
	owner "root"
	group "root"
	recursive true
	mode 0755
	action :create
end

directory node['hdp_repo']['artifacts_dir'] do
	owner "root"
	group "root"
	recursive true
	mode 0755
	action :create
end

remote_file node['hdp_repo']['jdk_bin'] do
	source node['hdp_repo']['jdk_source_bin']
	owner "root"
	owner "root"
	mode '00644'
	action :create_if_missing
end


# Take the ambari.repo we've downloaded and place it on the repo for distribution.
# AHO. Removed baseurl= because need to repolace host name in both baseurl and gpgkey= fields.
#cp /etc/yum.repos.d/ambari.repo $BASE_REPO_DIR/local.yum.repos.d/
# === Using Templates instead
# remote_file node['hdp_repo']['ambari_repo_artifact'] do
# 	source "file://#{node['hdp_repo']['ambari_repo_d']}"
# 	mode '00644'
# 	action :create_if_missing
# end

template node['hdp_repo']['ambari_repo_artifact'] do
	source "ambari.repo.erb"
	owner "root"
	group "root"
  	mode "0644"
	variables(
		:localRepoHostRepo => "#{node['hdp_repo']['repo_host']}/repos"
	)
end	

remote_file node['hdp_repo']['jdk_bin'] do
	source node['hdp_repo']['jdk_source_bin']
	mode '00644'
	action :create_if_missing
end
		
directory "#{baseRepoDir}/pub/epel/6/x86_64" do
	owner "root"
	group "root"
	mode 0755
	recursive true
	action :create
end

bash "repo-sync-ambari" do
	user "root"
	code "reposync -r ambari-1.x -p #{baseRepoDir}/ambari/centos6/1.x/GA --norepopath"
end
bash "create-repo-ambari" do
	code "createrepo --update #{baseRepoDir}/ambari/centos6/1.x/GA"
end

bash "repo-sync-Ambari-Updates" do
	user "root"
	code "reposync -r Updates-ambari-1.x -p #{baseRepoDir}/ambari/centos6/1.x/updates"
end
bash "create-repo-ambari-updates" do
	code "createrepo --update #{baseRepoDir}/ambari/centos6/1.x/updates"
end

bash "repo-sync-HDP-UTILS-16" do
	user "root"
	code "reposync -r HDP-UTILS-1.1.0.16 -p #{baseRepoDir}/HDP-UTILS-1.1.0.16/repos/centos6 --norepopath"
end
bash "create-repo-HDP-UTILS-16" do
	code "createrepo --update #{baseRepoDir}/HDP-UTILS-1.1.0.16/repos/centos6"
end

bash "repo-sync-HDP" do
	user "root"
	code "reposync -r HDP-1.x -p #{baseRepoDir}/HDP/centos6/1.x/GA --norepopath"
end
bash "create-repo-HDP" do
	code "createrepo --update #{baseRepoDir}/HDP/centos6/1.x/GA"
end

bash "repo-sync-HDP-Updates" do
	user "root"
	code "reposync -r Updates-HDP-1.x -p #{baseRepoDir}/HDP/centos6/1.x/updates --norepopath"
end
bash "create-repo-HDP-Updates" do
	code "createrepo --update #{baseRepoDir}/HDP/centos6/1.x/updates"
end

bash "repo-sync-HDP2" do
	user "root"
	code "reposync -r HDP-2.x -p #{baseRepoDir}/HDP/centos6/2.x/GA --norepopath"
end
bash "create-repo-HDP2" do
	code "createrepo --update #{baseRepoDir}/HDP/centos6/2.x/GA"
end

bash "repo-sync-HDP2-Updates" do
	user "root"
	code "reposync -r Updates-HDP-2.x -p #{baseRepoDir}/HDP/centos6/2.x/updates --norepopath"
end
bash "create-repo-HDP2-Updates" do
	code "createrepo --update #{baseRepoDir}/HDP/centos6/2.x/updates"
end

# bash "repo-sync-HDP-UTILS-15" do
# 	user "root"
# 	code "reposync -r HDP-UTILS-1.1.0.15 -p #{baseRepoDir}/HDP-UTILS-1.1.0.15/repos/centos6 --norepopath"
# end
# bash "create-repo-HDP-UTILS-15" do
# 	code "createrepo --update #{baseRepoDir}/HDP-UTILS-1.1.0.15/repos/centos6"
# end

# bash "repo-sync-HDP-1.3.0.0-GA" do
# 	user "root"
# 	code "reposync -r HDP-1.3.0.0 -p #{baseRepoDir}/HDP/centos6/1.x/GA/1.3.0.0 --norepopath"
# end
# bash "create-repo-HDP-1-3-0" do
# 	code "createrepo --update #{baseRepoDir}/HDP/centos6/1.x/GA/1.3.0.0"
# end

bash "repo-sync-epel" do
	user "root"
	code "reposync -r epel -p #{baseRepoDir}/pub/epel/6/x86_64 --norepopath"
end
bash "create-repo-epel" do
	code "createrepo --update #{baseRepoDir}/pub/epel/6/x86_64"
end

bash "repo-sync-centos" do
	user "root"
	code "reposync -r base -p #{baseRepoDir}/centos/6/os/x86_64 --norepopath"
end
bash "create-repo-centos" do
	code "createrepo --update #{baseRepoDir}/centos/6/os/x86_64"
end

bash "repo-sync-centos-updates" do
	user "root"
	code "reposync -r updates -p #{baseRepoDir}/centos/6/updates/x86_64 --norepopath"
	returns [0,1]
end
bash "create-repo-centos-updates" do
	code "createrepo --update #{baseRepoDir}/centos/6/updates/x86_64"
end

bash "repo-sync-centos-extras" do
	user "root"
	code "reposync -r extras -p #{baseRepoDir}/centos/6/extras/x86_64 --norepopath"
	returns [0,1]
end
bash "create-repo-centos-extras" do
	code "createrepo --update #{baseRepoDir}/centos/6/extras/x86_64"
end

bash "repo-sync-centos-plus" do
	user "root"
	code "reposync -r centosplus -p #{baseRepoDir}/centos/6/centosplus/x86_64 --norepopath"
end
bash "create-repo-centosplus" do
	code "createrepo --update #{baseRepoDir}/centos/6/centosplus/x86_64"
end

bash "repo-sync-centos-contrib" do
	user "root"
	code "reposync -r contrib -p #{baseRepoDir}/centos/6/contrib/x86_64 --norepopath"
end
bash "create-repo-centos-contrib" do
	code "createrepo --update #{baseRepoDir}/centos/6/contrib/x86_64"
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
	mode '00644'
	action :create_if_missing
end


