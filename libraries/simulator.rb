#
# Author:: Brenton Bartel
# Copyright (C) 2017, ROBLOX, Inc.
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
# Library:: simulator
#
require 'chef/resource'
require 'chef/provider'
require 'chef/provider/ruby_block'

module Xcode
  module Resources
    module XcodeSimulator
      # The 'xcode_simulator' custom resource to install and uninstall Xcode components.
      class Resource < Chef::Resource::LWRPBase
        self.resource_name = :xcode_simulator
        provides(:xcode_simulator)
        actions(:install, :uninstall)
        default_action(:install)

        attribute(:name, kind_of: String, name_attribute: true)
        attribute(:version, kind_of: String, required: true)
        attribute(:url, kind_of: String, required: true)
        attribute(:checksum, kind_of: String, required: true)
        attribute(:force, kind_of: [TrueClass, FalseClass], default: false)
      end

      # The 'xcode_simulator' custom resource provider to install and uninstall Xcode components.
      class Provider < Chef::Provider::LWRPBase
        provides(:xcode_simulator)
        use_inline_resources

        action :install do
          return if exist?
          raise unless Chef.node['platform_family'].eql?('mac_os_x')
          install_simulator
        end

        action :uninstall do
          directory install_dir do
            recursive true
            action :delete
          end if exist?
        end

        def install_simulator
          # If we force the install remove target folder if it exists.
          directory install_dir do
            recursive true
            action :delete
          end if new_resource.force && exist?

          if new_resource.url.end_with?('dmg')
            prepare_package
            install_package
            cleanup
          else
            raise 'Unsupported package provided Simulator installer must be provided as a DMG'
          end
        end

        def prepare_package
          remote_file "#{dmg_path}" do
            source new_resource.url
            checksum new_resource.checksum
          end

          execute "Prepare Simulator package [#{new_resource.name}]" do
            cwd Chef::Config[:file_cache_path]
            command <<-EOF
              hdiutil attach '#{dmg_path}' -mountpoint '/Volumes/#{identifier}' -quiet

              # Unpack the package
              rm -rf #{pkg_path}.expand
              pkgutil --expand /Volumes/#{identifier}/*.pkg #{pkg_path}.expand

              hdiutil detach '/Volumes/#{identifier}' || hdiutil detach '/Volumes/#{identifier}' -force

              # Adjust the install location (because no option exists during install)
              sed -i '' 's/<pkg-info/<pkg-info install-location="#{install_dir.gsub('/', '\\/')}"/' \\
                     #{::File.join("#{pkg_path}.expand", 'PackageInfo')}

              # Then repack package
              pkgutil --flatten #{pkg_path}.expand #{pkg_path}
              EOF
            only_if { ::File.exist?(dmg_path) }
          end
        end

        def install_package
          directory ::File.dirname(install_dir) do
            recursive true
          end

          execute "Install Simulator package [#{new_resource.name}]" do
            command "installer -pkg #{pkg_path} -target /"
            only_if { ::File.exist?(pkg_path) }
          end
        end

        def cleanup
          file pkg_path do
            action :delete
            only_if { ::File.exist?(pkg_path) }
          end

          directory "#{pkg_path}.expand" do
            recursive true
            action :delete
            only_if { ::Dir.exist?("#{pkg_path}.expand") }
          end
        end

        def install_dir
          "/Library/Developer/CoreSimulator/Profiles/Runtimes/#{new_resource.name}.simruntime"
        end

        def exist?
          new_resource.force ? false : ::Dir.exist?(install_dir)
        end

        def identifier
          ::File.basename(new_resource.url).split('-')[0]
        end

        def dmg_path
          ::File.join(Chef::Config[:file_cache_path], ::File.basename(new_resource.url))
        end

        def pkg_path
          ::File.join(Chef::Config[:file_cache_path], "#{::File.basename(identifier)}.pkg")
        end
      end
    end
  end
end
