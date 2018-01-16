# # encoding: utf-8

# Inspec test for recipe xcode::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe directory('/Applications/Xcode_9_1.app') do
  it { should be_owned_by 'root' }
  its('mode') { should cmp 0o0755 }
end

describe file('/Library/Preferences/com.apple.dt.Xcode.plist') do
  it { should be_owned_by 'root' }
  its('mode') { should cmp 0o0644 }
end

describe file("/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS\ 11.0.simruntime") do
  it { should be_owned_by 'root' }
  its('mode') { should cmp 0o1775 }
end
