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

With the 2.0.0 release this cookbook no longer installs Xcode directly from the default recipe.
Instead the cookbook now provides a LWRP to install Xcode with the options (default) to install multiple versions,
side by side. This side-by-side installation is especially useful for those that run build farms and need to
support multiple Xcode versions.

Attributes
----------

| Key                            | Type   | Description                             | Default                  |
|--------------------------------|--------|-----------------------------------------|--------------------------|
| `['xcode']['databag']`         | String | URL to the data bag on the Server that  | `xcode_verions`          |
|                                |        | contains the Xcode versions to install  |                          |
| `['xcode']['install_root']`    | String | Checksum of the Xcode DMG               | `nil`                    |

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
  xcode = data_bag_item(node['xcode']['databag'], version)
  xcode_app xcode['id'] do
    app xcode['app']
    url xcode['url']
    checksum xcode['checksum']
    action xcode['action']
    multi_install
    install_root node['xcode']['install_root'] unless node['xcode']['install_root'].nil?
    force xcode['force'] unless xcode['force'].nil?
  end
end
```
The following resource attributes come with defaults that can be overridden.

`multi_install` defaults to true meaning that the XCode installation will be moved to a folder within the 
`install_root` after the installation, given the examples above this will result in `/Applications/Xcode_7_3_1`.  
`install_root` is the root folder where XCode will be installed, it defaults to `/Applications`.  
`force` is an optional data_bag attribute that will `overwrite` an existing installation.

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
* License: Apache 2.0
