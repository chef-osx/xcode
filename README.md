Apple Xcode Cookbook
==============

Installs Apple Xcode and command line tools on OS X Lion, Mountain Lion, Mavericks, Yosemite, and El Capitan.

** Note: ** The official [build-essential](https://supermarket.chef.io/cookbooks/build-essential) cookbook now supports installing the command line tools, and is better-maintained than this cookbook.

Requirements
------------

#### Platforms

* `mac_os_x`

#### Cookbooks

* `dmg`

The DMGs are not accessible from Apple directly without logging into the developer center.
You must place the DMGs on a fileserver yourself and set the URL attributes below.
The intended filenames are documented in the attributes file.

Attributes
----------

| Key                            | Type   | Description                             | Default                  |
|--------------------------------|--------|-----------------------------------------|--------------------------|
| `['xcode']['url']`             | String | URL to the Xcode DMG                    | `nil`                    |
| `['xcode']['checksum']`        | String | Checksum of the Xcode DMG               | (in the attributes file) |
| `['xcode']['cli']['url']`      | String | URL to the Xcode Command-Line Tools DMG | `nil`                    |
| `['xcode']['cli']['checksum']` | String | Checksum of the Xcode CLI DMG           | (in the attributes file) |

Usage
-----

Just include `xcode` in your node's `run_list` and set the attributes above.

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[xcode]"
  ]
}
```

Test
----
Prerequisites:
- HTTP server which provides `Xcode` installers.
If the host machine has installed python, just run in the directory where `Xcode` installers are:
```
python -m SimpleHTTPServer 80
```
- Vagrant 1.8.6
- VirtualBox 5.1.10 + ExtensionPack
- ChefDK latest

This cookbook use the test-kitchen tool for developing infrastructure code. To verify cookbook execute command in terminal 
```
kitchen test
```

Bugs
----

Only supports Mac OS X 10.7 - 10.11 at the moment. Pull requests are welcome!

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Submit a Pull Request using Github

License and Authors
-------------------

* Author: Julian C. Dunn (<jdunn@aquezada.com>)
* License: Apache 2.0
