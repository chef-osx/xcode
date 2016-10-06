#
# Author:: Antoni S. Baranski (<antek.baranski@gmail.com>)
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
# Cookbook Name:: xcode
# Library:: app
#
require 'chef/resource'
require 'chef/provider'
require 'chef/provider/ruby_block'

module Xcode
  module Resources
    module XcodeApp
      # The 'xcode_app' custom resource to install and uninstall Xcode components.
      class Resource < Chef::Resource::LWRPBase
        self.resource_name = :xcode_app
        provides(:xcode_app)
        actions(:install, :uninstall)
        default_action(:install)

        attribute(:version, kind_of: String, name_attribute: true)
        attribute(:url, kind_of: String, required: true)
        attribute(:checksum, kind_of: String, required: true)
        attribute(:app, kind_of: String, required: true)
        attribute(:multi_install, kind_of: [TrueClass, FalseClass], default: true)
        attribute(:install_root, kind_of: String, default: '/Applications')
        attribute(:force, kind_of: [TrueClass, FalseClass], default: false)
      end

      # The 'xcode_app' custom resource provider to install and uninstall Xcode components.
      class Provider < Chef::Provider::LWRPBase
        provides(:xcode_app)
        use_inline_resources

        action :install do
          return if exist?
          raise unless Chef.node.platform_family.eql?('mac_os_x')
          install_app
        end

        action :uninstall do
          directory install_dir do
            recursive true
            action :delete
          end if exist?
        end

        def install_app
          # If we force the install remove target folder if it exists.
          directory install_dir do
            recursive true
            action :delete
          end if new_resource.force && exist?

          if new_resource.url.end_with?('dmg')
            install_dmg
          else
            raise 'Unsupported package provided Xcode installer must be provided as a DMG'
          end

          post_install
          accept_eula
          delete_installer_file if exist?
        end

        def install_dmg
          dmg_package new_resource.app do
            source new_resource.url
            checksum new_resource.checksum
            dmg_name ::File.basename(new_resource.url, '.dmg')
            owner 'root'
            type 'app'
            action :install
          end
        end

        # The `post_install` function is only called if the function 'install_app' is called.
        def post_install
          ruby_block 'Xcode post install' do
            block do
              if new_resource.multi_install || !new_resource.install_root.eql?('/Applications')
                ::File.rename('/Applications/Xcode.app', install_dir)
              end
              # Install any additional packages hiding in the Xcode installation path
              xcode_packages =
                ::Dir.entries("#{install_dir}/Contents/Resources/Packages/").select { |f| !::File.directory? f }
              xcode_packages.each do |pkg|
                execute "Installing Xcode package [#{pkg}]" do
                  command "sudo installer -pkg #{install_dir}/Contents/Resources/Packages/#{pkg} -target /"
                end
              end unless xcode_packages.nil?
              execute 'xcode-select' do
                command "xcode-select -s #{install_dir}/Contents/Developer"
              end
            end
            only_if { ::Dir.exist?('/Applications/Xcode.app') }
          end
        end

        # The `accept_eula` function is only called if the function 'install_app' is called.
        def accept_eula
          # Accept the Xcode license, this creates the /Library/Preferences/com.apple.dt.Xcode.plist file
          execute 'Accept xcode license' do
            command "#{install_dir}/Contents/Developer/usr/bin/xcodebuild -license accept"
            action :run
            only_if { ::File.exist?("#{install_dir}/Contents/Developer/usr/bin/xcodebuild") }
            # TODO: Do a proper version check such that the oldest version is always accepted.
            # only_if { newer?("#{install_dir}/Contents/Developer/usr/bin/xcodebuild -version") }
          end
        end

        def install_dir
          ::File.join(new_resource.install_root,
                      "Xcode#{new_resource.multi_install ? "_#{new_resource.version}" : ''}.app")
        end

        def exist?
          new_resource.force ? false : Dir.exist?(install_dir)
        end

        # Cleanup the installer file
        def delete_installer_file
          file ::File.join(Chef::Config[:file_cache_path], ::File.basename(new_resource.url, '.dmg')) do
            action :delete
            only_if do
              ::File.exist?(::File.join(Chef::Config[:file_cache_path],
                                        ::File.basename(new_resource.url, '.dmg')))
            end
          end
        end
      end
    end
  end
end
