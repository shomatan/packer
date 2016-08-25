#!/bin/bash
#export PATH=/opt/chef/embedded/bin:$PATH
yum -y install ruby

cd /tmp/tests
bundle install --path=vendor
bundle exec rake spec

yum -y remove ruby
