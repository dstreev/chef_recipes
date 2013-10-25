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

include_recipe "selinux::disabled"
include_recipe "ntp"
inlcude_recipe "iptables::diabled"
include_recipe "java"

# Distribute ssh keys.
# Private Key
directory ".ssh" do
	owner node['hdp-prep']['ssh']['user']
	group node['hdp-prep']['ssh']['user']
	mode 0700
	action :create_if_missing
end

template ".ssh/id_rsa" do
  source "id_rsa"
  owner node['hdp-prep']['ssh']['user']
  group node['hdp-prep']['ssh']['user']
  mode "0600"
end

template ".ssh/id_rsa.pub" do
  source "id_rsa.pub"
  owner node['hdp-prep']['ssh']['user']
  group node['hdp-prep']['ssh']['user']
  mode "0600"
end

template ".ssh/authorized_keys" do
  source "id_rsa.pub"
  owner node['hdp-prep']['ssh']['user']
  group node['hdp-prep']['ssh']['user']
  mode "0600"
end

