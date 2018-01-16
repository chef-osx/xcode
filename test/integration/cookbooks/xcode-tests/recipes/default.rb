#
# Author:: Antek S. Baranski (<antek.baranski@gmail.com>)
# Copyright (C) 2016, ROBLOX, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
#
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Cookbook Name:: xcode-tests
# Recipe:: default
#

include_recipe 'xcode'

xcode_versions = data_bag(node['xcode']['app']['databag'])

xcode_versions.each do |version|
  xcode = data_bag_item(node['xcode']['app']['databag'], version)

  xcode_app xcode['id'] do
    url xcode['url']
    checksum xcode['checksum']
    app xcode['app']
    install_suffix xcode['id']
    install_root node['xcode']['install_root'] unless node['xcode']['install_root'].nil?
    force xcode['force'] unless xcode['force'].nil?
    action xcode['action']
  end
end

link "/Applications/Xcode.app" do
  to "Xcode_#{node['xcode']['link_id']}.app"
  owner 'root'
  group 'wheel'
end

simulator_versions = data_bag(node['xcode']['sim']['databag'])

simulator_versions.each do |version|
  simulator = data_bag_item(node['xcode']['sim']['databag'], version)

  xcode_simulator simulator['name'] do
    url simulator['url']
    checksum simulator['checksum']
    action simulator['action']
  end
end
