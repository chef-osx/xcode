name             'xcode'
maintainer       'Urbandecoder Labs'
maintainer_email 'jdunn@aquezada.com'
license          'Apache 2.0'
description      'Provides custom resource to install Apple XCode'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.1.1'

issues_url 'https://github.com/chef-osx/xcode/issues' if respond_to?(:issues_url)
source_url 'https://github.com/chef-osx/xcode' if respond_to?(:source_url)

supports         'mac_os_x'

depends          'dmg'
