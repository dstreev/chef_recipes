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

baseRepoDir = node['hdp_repo']['base_repo_dir']

# Other Repos for CentOS
bash "repo-sync-centos" do
  user "root"
  code "reposync -r base -p #{baseRepoDir}/centos/6/os/x86_64 --norepopath"
  returns [0,1]
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
