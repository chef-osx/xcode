shared_examples 'simple installation of xcode with CLI' do
  describe 'Check Xcode CLI' do
    describe command('xcode-select -p') do
      its(:exit_status) { should eq 0 }
    end

    describe command('gcc -v') do
      its(:exit_status) { should eq 0 }
    end

    describe command('make -v') do
      its(:exit_status) { should eq 0 }
    end
  end

  describe 'Check xcodebuild' do
    describe command('xcodebuild -version') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain('Xcode') }
      its(:stdout) { should contain('Build version') }
    end
  end
end