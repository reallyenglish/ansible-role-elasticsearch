require 'spec_helper'
require 'serverspec'

es_package_name = 'elasticsearch'
es_service_name = 'elasticsearch'
es_config_path  = '/etc/elasticsearch'
es_user_name    = 'elasticsearch'
es_user_group   = 'elasticsearch'

case os[:family]
when 'freebsd'
  es_package_name = 'elasticsearch2'
  es_config_path = '/usr/local/etc/elasticsearch'
end

describe service(es_service_name) do
  it { should be_running }
end

describe package(es_package_name) do
  it { should be_installed }
end 

describe file("#{ es_config_path }/elasticsearch.yml") do
  its(:content) { should match /cluster\.name: testcluster/ }
  its(:content) { should match /node\.name: testnode/ }
  its(:content) { should match /discovery.zen.ping.multicast.enabled: false/ }
  its(:content) { should match /discovery.zen.ping.unicast.hosts: \[ "192.168.1.1:9300" \]/ }
  it { should be_owned_by es_user_name }
  it { should be_grouped_into es_user_group }
  it { should be_mode 440 }
end
