# # encoding: utf-8

# Inspec test for recipe xcode::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe directory('/Applications/Xcode_7_3_1.app') do
  it { should be_owned_by 'root' }
  its('mode') { should cmp '00755' }
end

describe file('/Library/Preferences/com.apple.dt.Xcode.plist') do
  it { should be_owned_by 'root' }
  its('mode') { should cmp '00644' }
end

describe file("/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS\ 9.3.simruntime") do
  it { should be_owned_by 'root' }
  its('mode') { should cmp '01775' }
end
