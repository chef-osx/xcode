#
# Author:: Julian C. Dunn (<jdunn@aquezada.com>)
# Copyright (c) 2014, Julian Dunn
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

default['xcode']['url'] = nil # should point to xcode_5.0.2.dmg
default['xcode']['checksum'] = '530cf754ca4350eaae6eff08019d3d411d5e38a9fd0e843c439d6337f18b3457'

case node['platform_version'].to_f
when 10.7
  default['xcode']['cli']['url'] = 'https://devimages.apple.com.edgekey.net/downloads/xcode/command_line_tools_for_xcode_os_x_lion_april_2013.dmg'
  default['xcode']['cli']['checksum'] = '20a3e1965c685c6c079ffe89b168c3975c9a106c4b33b89aeac93c8ffa4e0523'
  default['xcode']['cli']['package_name'] = 'Command Line Tools (Lion)'
  default['xcode']['cli']['package_type'] = 'mpkg'
  default['xcode']['cli']['package_id'] = 'com.apple.pkg.DeveloperToolsCLI'
  default['xcode']['cli']['volumes_dir'] = 'Command Line Tools (Lion)'
when 10.8
  default['xcode']['cli']['url'] = 'https://devimages.apple.com.edgekey.net/downloads/xcode/command_line_tools_os_x_mountain_lion_for_xcode_october_2013.dmg'
  default['xcode']['cli']['checksum'] = '635c1cf6c93b397ef882c27211ef01e54e5b1d9d2d92fc870f1e07efd54cfe35'
  default['xcode']['cli']['package_name'] = 'Command Line Tools (Mountain Lion)'
  default['xcode']['cli']['package_type'] = 'mpkg'
  default['xcode']['cli']['package_id'] = 'com.apple.pkg.DeveloperToolsCLI'
  default['xcode']['cli']['volumes_dir'] = 'Command Line Tools (Mountain Lion)'
when 10.9
  default['xcode']['cli']['url'] = nil # should point to command_line_tools_os_x_mavericks_for_xcode__late_october_2013.dmg
  default['xcode']['cli']['checksum'] = 'db764b9f13ae8c7134dfd6297654fb9ed09502708fdbc88e32f5390258f4b062'
  default['xcode']['cli']['package_name'] = 'Command Line Tools (OS X 10.9)'
  default['xcode']['cli']['package_type'] = 'pkg'
  default['xcode']['cli']['package_id'] = 'com.apple.pkg.CLTools_Executables'
  default['xcode']['cli']['volumes_dir'] = 'Command Line Developer Tools'
end
