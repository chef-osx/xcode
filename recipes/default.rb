#
# Cookbook Name:: xcode
# Recipe:: default
#
# Copyright 2013, Urbandecoder Labs LLC
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

Chef::Log.info("xcode package type: '#{node['xcode']['package_type']}'.")

case node['xcode']['package_type']
when 'dmg'
  dmg_package "Xcode" do
    source node['xcode']['url']
    checksum node['xcode']['checksum']
    action :install
  end
when 'xip'

  # TODO: add a version check. (i.e. "xcodebuild -version | grep #{node['xcode']['version']}")
  if ::Dir.exist? "/Applications/Xcode.app"
    Chef::Log.info("xcode version #{node['xcode']['version']} is alread installed. Nothing to do.")
  else
    # Instructions for how to install XCode via the command line were taken from:
    # http://stackoverflow.com/a/39489446
    Chef::Log.info("xcode is NOT installed.  Installing...")

    # extract the name of the archive from the download URL
    file_name = File.basename(node['xcode']['url'])

    # download the remote xip archive
    remote_file "#{Chef::Config[:file_cache_path]}/#{file_name}" do
      source node['xcode']['url']
      checksum node['xcode']['checksum']
      backup false
      mode 0644
      owner "root"
      group "wheel"
      action :create
      not_if { ::File.exist? "#{Chef::Config[:file_cache_path]}/#{file_name}" }
    end

    execute 'Verify the signature and certificate chain that signed the archive' do
      command "pkgutil --check-signature #{Chef::Config[:file_cache_path]}/#{file_name}"
      cwd Chef::Config[:file_cache_path]
    end

    execute 'Extract the xcode xip archive' do
      command "xar -xf #{Chef::Config[:file_cache_path]}/#{file_name}"
      cwd Chef::Config[:file_cache_path]
    end

    # Obtain a PBZX v2 unpacker and... unpack the packed stuff.
    # Install PBZX v2 unpacker
    cookbook_file "#{Chef::Config[:file_cache_path]}/parse_pbzx2.py" do
      source 'parse_pbzx2.py'
      owner 'root'
      group 'wheel'
      mode '0755'
      action :create
    end

    # Unpack the PBZX stream
    execute 'Unpack the PBZX stream' do
      command 'python parse_pbzx2.py Content'
      cwd Chef::Config[:file_cache_path]
    end

    # Decompress the archive (there should only be one chunk, "part00").
    execute 'Unpack the CPIO archive as a privileged user' do
      command 'cpio -izmdu 0<Content.part00.cpio.xz'
      cwd Chef::Config[:file_cache_path]
    end

    # Move the resulting Xcode app bundle into /Applications
    execute 'Move the resulting Xcode app bundle into /Applications' do
      command 'mv -f Xcode.app /Applications/Xcode.app'
      cwd Chef::Config[:file_cache_path]
    end

    # Cleanup
    # remove the PBZX v2 unpacker
    file "#{Chef::Config[:file_cache_path]}/parse_pbzx2.py" do
      backup false
      action :delete
      only_if { ::File.exist? "#{Chef::Config[:file_cache_path]}/parse_pbzx2.py" }
    end

    # remove the Content directory
    file "#{Chef::Config[:file_cache_path]}/Content" do
      backup false
      action :delete
      only_if { ::File.exist? "#{Chef::Config[:file_cache_path]}/Content" }
    end

    # Remove the compressed archive
    file "#{Chef::Config[:file_cache_path]}/Content.part00.cpio.xz" do
      backup false
      action :delete
      only_if { ::File.exist? "#{Chef::Config[:file_cache_path]}/Content.part00.cpio.xz" }
    end

    # Remove the downloaded xip file
    file "#{Chef::Config[:file_cache_path]}/#{file_name}" do
      backup false
      action :delete
      only_if { ::File.exist? "#{Chef::Config[:file_cache_path]}/#{file_name}" }
    end
  end
else
  raise "Unsupported xcode package type #{node['xcode']['package_type']}!  Allowed types are ['dmg', 'xip']."
end

dmg_package node['xcode']['cli']['package_name'] do
  source node['xcode']['cli']['url']
  checksum node['xcode']['cli']['checksum']
  volumes_dir node['xcode']['cli']['volumes_dir']
  type node['xcode']['cli']['package_type']
  package_id node['xcode']['cli']['package_id']
  action :install
end

template "/Library/Preferences/com.apple.dt.Xcode.plist" do
  source "com.apple.dt.Xcode.plist.erb"
  owner "root"
  group "wheel"
  mode 00644
  variables({
    :last_gm_license => node['xcode']['last_gm_license'],
    :version => node['xcode']['version']
  })
  action :create
end
