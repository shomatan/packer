require 'spec_helper'

# SELinux
describe command('getenforce') do
  its(:stdout) { should match /Disabled/ }
end
describe file('/etc/selinux/config') do
  its(:content) { should match /^SELINUX=disabled/ }
end

# firewall
describe service('firewalld') do
  it { should_not be_enabled }
  it { should_not be_running }
end

# Repositories
%w{epel remi remi-php70 rpmforge}.each do |repo|
  describe yumrepo(repo) do
    it { should exist }
    it { should_not be_enabled }
  end
end

# Packages
%w{sudo wget htop nmap zsh}.each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

# cron
describe package('cronie-anacron') do
  it { should_not be_installed }
end
describe package('cronie-noanacron') do
  it { should be_installed }
end
describe service('crond') do
  it { should be_enabled }
  it { should be_running }
end

# ntp client
describe package('chrony') do
  it { should be_installed }
end
describe service('chronyd') do
  it { should be_enabled }
  it { should be_running }
end

# sudoers
describe file('/etc/pam.d/su') do
  it { should exist }
  its(:content) { should match /auth\t\trequired\tpam_wheel.so use_uid/ }
end
describe file('/etc/sudoers') do
  it { should exist }
  its(:content) { should match /%wheel.*ALL=\(ALL\).*ALL/ }
  its(:content) { should match /Defaults:%wheel    !requiretty/ }
end

# User vagrant
describe user('vagrant') do
  it { should exist }
  it { should belong_to_group 'wheel' }
  it { should belong_to_group 'vagrant' }
  it { should have_authorized_key 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key' }
end
describe file('/etc/sudoers.d/vagrant') do
  it { should exist }
  it { should be_mode 440 }
  its(:content) { should match /vagrant.*ALL=\(ALL\).*NOPASSWD:.*ALL/ }
end
