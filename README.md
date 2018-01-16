Apple Xcode Cookbook
==============

Installs Apple Xcode OS X Lion, Mountain Lion, Mavericks, Yosemite, El Capitan and Sierra. Xcode command
line tools are installed through the [build-essential](https://supermarket.chef.io/cookbooks/build-essential).

limitations
-----------

The cookbook does not yet support installation of Xcode > 8 which comes as a XIP archive, this is being worked on.
Requirements
------------

#### Platforms

* `mac_os_x`

#### Cookbooks

* `dmg`

The DMGs are not accessible from Apple directly without logging into the developer center,
you must place the DMGs on your own fileserver and list them in a data bag on your Chef server.

#### LWRP

## Xode

With the 2.0.0 release this cookbook no longer installs Xcode directly from the default recipe.
Instead the cookbook now provides a LWRP to install Xcode with the options (default) to install multiple versions,
side by side. This side-by-side installation is especially useful for those that run build farms and need to
support multiple Xcode versions.

Attributes
----------

| Key                                | Type   | Description                               | Default              |
|------------------------------------|--------|-------------------------------------------|----------------------|
| `['xcode']['app']['databag']`      | String | Name of the data bag on the Server that   | `xcode_app_versions` |
|                                    |        | contains the Xcode versions to install    |                      |
| `['xcode']['app']['install_root']` | String | Root folder where Xcode will be installed | `nil`                |
| `['xcode']['sim']['databag']`      | String | Name of the data bag on the Server that   | `xcode_sim_versions` |
|                                    |        | contains the Simulators to install        |                      |

Usage
-----

Just include `xcode` in your node's `run_list` this will ensure that the `dmg` cookbook is included and then you
can access the `xcode_app` custom resource.
```json
{
  "name":"my_node",
  "run_list": [
    "recipe[xcode]"
  ]
}
```
The data bag needs to provide the following attributes at the very least:
```json
  "id": "7_3_1",
  "app": "Xcode",
  "url": "YOUR URL HERE",
  "checksum": "bb0dedf613e86ecb46ced945913fa5069ab716a0ade1035e239d70dee0b2de1b",
  "action": "(un)install"
```
You can then call the `xcode_app` custom resource like this:
```ruby
xcode_versions.each do |version|
  xcode = data_bag_item(node['xcode']['app']['databag'], version)
  xcode_app xcode['id'] do
    app xcode['app']
    url xcode['url']
    checksum xcode['checksum']
    action xcode['action']
    install_suffix xcode['id']
    install_root node['xcode']['install_root'] unless node['xcode']['install_root'].nil?
    force xcode['force'] unless xcode['force'].nil?
  end
end
```
The following resource attributes come with defaults that can be overridden.

`install_suffix` if not empty will be appended to installation folder name as it's moved within the `install_root`.
`install_root` is the root folder where XCode will be installed, it defaults to `/Applications`.  
`force` is an optional data_bag attribute that will `overwrite` an existing installation.

## Simulators

Similar to Xcode App, it is advised to download the desired DMGs to local store. To see what is available,
below is an example Ruby script that can be used to get a list of URLs:
```ruby
require 'json'

xcode_info = '/Applications/Xcode.app/Contents/Info.plist'
xcode_version = `/usr/libexec/PlistBuddy -c "Print :DTXcode" #{xcode_info}`.chomp.to_i.to_s.split(//).join('.')
xcode_uuid = `/usr/libexec/PlistBuddy -c "Print :DVTPlugInCompatibilityUUID" #{xcode_info}`.chomp

if Gem::Version.new(xcode_version) >= Gem::Version.new('8.1')
  index_url = "https://devimages-cdn.apple.com/downloads/xcode/simulators/index-#{xcode_version}-#{xcode_uuid}.dvtdownloadableindex"
else
  index_url = "https://devimages.apple.com.edgekey.net/downloads/xcode/simulators/index-#{xcode_version}-#{xcode_uuid}.dvtdownloadableindex"
end

JSON.parse(`curl -Ls #{index_url} | plutil -convert json -o - -`)['downloadables'].map do |sim|
  sim_version_major = sim['version'].to_s.split('.')[0]
  sim_version_minor = sim['version'].to_s.split('.')[1]

  name = sim['name']
    .sub('$(DOWNLOADABLE_VERSION_MAJOR)', sim_version_major)
    .sub('$(DOWNLOADABLE_VERSION_MINOR)', sim_version_minor)

  identifier = sim['identifier']
    .sub('$(DOWNLOADABLE_VERSION_MAJOR)', sim_version_major)
    .sub('$(DOWNLOADABLE_VERSION_MINOR)', sim_version_minor)

  source = sim['source']
    .sub('$(DOWNLOADABLE_IDENTIFIER)', identifier)
    .sub('$(DOWNLOADABLE_VERSION)', sim['version'])

  puts "#{name} - SDK #{sim['version']} :"
  puts "    #{source}"
end
```

The data bag needs to provide the following attributes at the very least:
```json
  "id": "iOS_10_1",
  "version": "10.1.1.1476902849",
  "name": "iOS 10.1",
  "url": "YOUR URL HERE",
  "checksum": "bb0dedf613e86ecb46ced945913fa5069ab716a0ade1035e239d70dee0b2de1b",
  "action": "(un)install"
````

`name` as provided by `InstallPrefix` in download index (ex: `/Library/Developer/CoreSimulator/Profiles/Runtimes`)


Notes
-----
When testing, ensure the VM has sufficient space for Xcode & simulators.

Bugs
----
Supports Mac OS X 10.7 and higher. Pull requests are welcome!

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Submit a Pull Request using Github

License and Authors
-------------------

* Author: Julian C. Dunn (<jdunn@aquezada.com>)
* Contributor: Antek S. Baranski (<antek.baranski@gmail.com>)
* Contributor: Brenton Bartel (<brantone@letrabb.com>)
* License: Apache 2.0
