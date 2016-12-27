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

file_basename = ::File.basename(node['xcode']['url'])
installer_path = "#{Chef::Config[:file_cache_path]}/#{file_basename}"
installer_extension = ::File.extname installer_path

if ::Dir.exist? '/Applications/Xcode.app'
  Chef::Log.info('Xcode already installed.')
else
  remote_file "Download #{file_basename}" do
    backup false
    path installer_path
    source node['xcode']['url']
    checksum node['xcode']['checksum']
    not_if { ::File.exist? installer_path }
  end

  case installer_extension
  when '.dmg'
    dmg_package 'Xcode' do
      file installer_path
      action :install
      end
  when '.xip'
    include_recipe 'homebrew'
    package 'xz'

    remote_file 'Download PBZX v2 unpacker' do
      backup false
      path "#{Chef::Config[:file_cache_path]}/parse_pbzx2.py"
      source 'https://gist.githubusercontent.com/pudquick/ff412bcb29c9c1fa4b8d/raw/24b25538ea8df8d0634a2a6189aa581ccc6a5b4b/parse_pbzx2.py'
      not_if { ::File.exist? "#{Chef::Config[:file_cache_path]}/Content" }
    end

    execute 'Verify the signature and certificate chain that signed the archive' do
      command "pkgutil --check-signature #{installer_path}"
      cwd Chef::Config[:file_cache_path]
    end

    execute 'Extract the PBZX stream from the archive' do
      command "xar -xf #{file_basename} Content -C ./"
      cwd Chef::Config[:file_cache_path]
    end

    execute 'Unpack PBZX archive' do
      command 'python parse_pbzx2.py Content'
      cwd Chef::Config[:file_cache_path]
    end

    file "#{Chef::Config[:file_cache_path]}/Content" do
      backup false
      action :delete
      only_if { ::File.exist? "#{Chef::Config[:file_cache_path]}/Content" }
    end

    execute 'Decompress the archive' do
      command 'xz -d Content.part00.cpio.xz'
      cwd Chef::Config[:file_cache_path]
    end

    execute 'Unpack the CPIO archive' do
      command 'cpio --quiet -idm < ./Content.part00.cpio'
      cwd Chef::Config[:file_cache_path]
    end

    file "#{Chef::Config[:file_cache_path]}/Content.part00.cpio" do
      backup false
      action :delete
      only_if { ::File.exist? "#{Chef::Config[:file_cache_path]}/Content.part00.cpio" }
    end

    execute 'Move the resulting Xcode app bundle into /Applications' do
      command 'mv Xcode.app /Applications/Xcode.app'
      cwd Chef::Config[:file_cache_path]
    end

    file installer_path do
      backup false
      action :delete
      only_if { ::Dir.exist? installer_path }
    end
  else
    Chef::Log.error("Not supported file extension: '#{installer_extension}'.")
  end
end

execute 'Switch Xcode' do
  command 'xcode-select --switch /Applications/Xcode.app/Contents/Developer'
  not_if { system('xcodebuild -version > /dev/null 2>&1') }
end

dmg_package node['xcode']['cli']['package_name'] do
  source node['xcode']['cli']['url']
  checksum node['xcode']['cli']['checksum']
  volumes_dir node['xcode']['cli']['volumes_dir']
  type node['xcode']['cli']['package_type']
  package_id node['xcode']['cli']['package_id']
  action :install
end

template '/Library/Preferences/com.apple.dt.Xcode.plist' do
  source 'com.apple.dt.Xcode.plist.erb'
  mode 00644
  variables({
    :last_gm_license => node['xcode']['last_gm_license'],
    :version => node['xcode']['version']
  })
  action :create
end
