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

case node["platform_version"]
when /^10\.7/
  default['xcode']['url'] = nil # should point to xcode4620419895a.dmg
  default['xcode']['checksum'] = '3057224339823dae8a56943380a438065e92cff1ad4ab5a6a84f94f7a94dc035'
  default["xcode"]["package_type"] = "dmg"
  default['xcode']['last_gm_license'] = "EA0720"
  default['xcode']['version'] = "4.6.2"

  default['xcode']['cli']['url'] = nil # should point to xcode462_cltools_10_76938260a.dmg
  default['xcode']['cli']['checksum'] = '20a3e1965c685c6c079ffe89b168c3975c9a106c4b33b89aeac93c8ffa4e0523'
  default['xcode']['cli']['package_name'] = 'Command Line Tools (Lion)'
  default['xcode']['cli']['package_type'] = 'mpkg'
  default['xcode']['cli']['package_id'] = 'com.apple.pkg.DeveloperToolsCLI'
  default['xcode']['cli']['volumes_dir'] = 'Command Line Tools (Lion)'
when /^10\.8/
  default["xcode"]["url"] = nil # should point to xcode_5.1.1.dmg
  default["xcode"]["checksum"] = "5bd3c1792b695dae3c96065a9cc02215ec2fab6aecbf708a66b7d19fa65ff967"
  default["xcode"]["package_type"] = "dmg"
  default["xcode"]["last_gm_license"] = "EA0720"
  default["xcode"]["version"] = "5.1.1"

  default["xcode"]["cli"]["url"] = nil # should point to command_line_tools_for_osx_mountain_lion_april_2014.dmg
  default["xcode"]["cli"]["checksum"] = "2ce8cb402efe7a1fe104759d9f32bed3c9b5e9f9db591f047702ae5dc7f3d1ac"
  default["xcode"]["cli"]["package_name"] = "Command Line Tools (Mountain Lion)"
  default["xcode"]["cli"]["package_type"] = "mpkg"
  default["xcode"]["cli"]["package_id"] = "com.apple.pkg.DeveloperToolsCLI"
  default["xcode"]["cli"]["volumes_dir"] = "Command Line Tools (Mountain Lion)"
when /^10\.9/
  default["xcode"]["url"] = nil # should point to Xcode_6.2.dmg
  default["xcode"]["checksum"] = "00545c078470c14e6a53204324e2c10283c18c86d3a9f580bf90cbe97c6c28ec"
  default["xcode"]["package_type"] = "dmg"
  default["xcode"]["last_gm_license"] = "EA1187"
  default["xcode"]["version"] = "6.2"

  default["xcode"]["cli"]["url"] = nil # should point to commandlinetoolsosx10.9forxcode6.2.dmg
  default["xcode"]["cli"]["checksum"] = "e99276895a57b0beeecc2b73304f479e7d0061aead5c40f690c8c74e702f113d"
  default["xcode"]["cli"]["package_name"] = "Command Line Tools (OS X 10.9)"
  default["xcode"]["cli"]["package_type"] = "pkg"
  default["xcode"]["cli"]["package_id"] = "com.apple.pkg.CLTools_Executables"
  default["xcode"]["cli"]["volumes_dir"] = "Command Line Developer Tools"
when /^10\.10/
  default["xcode"]["url"] = nil # should point to Xcode_7.2.dmg
  default["xcode"]["checksum"] = "6f08ddabfb159143e9857de1668e5fdb04ba92b77297f7a1d50cf467be7222c8"
  default["xcode"]["package_type"] = "dmg"
  default["xcode"]["last_gm_license"] = "EA1327"
  default["xcode"]["version"] = "7.2"

  default["xcode"]["cli"]["url"] = nil # should point to Command_Line_Tools_OS_X_10.10_for_Xcode_7.2.dmg
  default["xcode"]["cli"]["checksum"] = "b763127af49093eb763af5793bd6416116431ec3f57ef2d665329120ad9d32ec"
  default["xcode"]["cli"]["package_name"] = "Command Line Tools (OS X 10.10)"
  default["xcode"]["cli"]["package_type"] = "pkg"
  default["xcode"]["cli"]["package_id"] = "com.apple.pkg.CLTools_Executables"
  default["xcode"]["cli"]["volumes_dir"] = "Command Line Developer Tools"
when /^10\.11/
  default["xcode"]["url"] = nil # should point to Xcode_7.3.1.dmg or Xcode_8.1.0.xip
  default["xcode"]["checksum"] = "30378e76f7d1adcf3573fc990bd7b46e0939b466b83338ba8f4290444462e5da"
  default["xcode"]["package_type"] = "xip"
  default["xcode"]["last_gm_license"] = "EA1421"
  default["xcode"]["version"] = "8.1"

  default["xcode"]["cli"]["url"] = nil # should point to Command_Line_Tools_OS_X_10.11_for_Xcode_7.3.1.dmg
  default["xcode"]["cli"]["checksum"] = "0c80753d207fa2254bcc1c880d4d8907071241f3f2e092c7caa87e340245835a"
  default["xcode"]["cli"]["package_name"] = "Command Line Tools (OS X 10.11)"
  default["xcode"]["cli"]["package_type"] = "pkg"
  default["xcode"]["cli"]["package_id"] = "com.apple.pkg.CLTools_Executables"
  default["xcode"]["cli"]["volumes_dir"] = "Command Line Developer Tools"
when /^10\.12/
  default["xcode"]["url"] = nil # should point to Xcode_7.3.1.dmg or Xcode_8.1.0.xip
  default["xcode"]["checksum"] = "30378e76f7d1adcf3573fc990bd7b46e0939b466b83338ba8f4290444462e5da"
  default["xcode"]["package_type"] = "xip"
  default["xcode"]["last_gm_license"] = "EA1421"
  default["xcode"]["version"] = "8.1"

  default["xcode"]["cli"]["url"] = nil # should point to Command_Line_Tools_OS_X_10.11_for_Xcode_7.3.1.dmg
  default["xcode"]["cli"]["checksum"] = "0c80753d207fa2254bcc1c880d4d8907071241f3f2e092c7caa87e340245835a"
  default["xcode"]["cli"]["package_name"] = "Command Line Tools (OS X 10.11)"
  default["xcode"]["cli"]["package_type"] = "pkg"
  default["xcode"]["cli"]["package_id"] = "com.apple.pkg.CLTools_Executables"
  default["xcode"]["cli"]["volumes_dir"] = "Command Line Developer Tools"
end
