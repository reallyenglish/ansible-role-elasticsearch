require 'spec_helper'
require 'serverspec'

es_package_name = 'elasticsearch'
es_service_name = 'elasticsearch'
es_config_path  = '/etc/elasticsearch'
es_user_name    = 'elasticsearch'
es_user_group   = 'elasticsearch'

es_plugin_command = '/usr/share/elasticsearch/bin/plugin'

case os[:family]
when 'freebsd'
  es_package_name = 'elasticsearch2'
  es_config_path = '/usr/local/etc/elasticsearch'
  es_plugin_command = '/usr/local/bin/elasticsearch-plugin'
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
  its(:content) { should match /discovery.zen.ping.unicast.hosts: \[ "10.0.2.15" \]/ }
  its(:content) { should match /network.publish_host: \[ "10.0.2.15" \]/ }
  its(:content) { should match /http\.cors\.enabled: true/ }
  its(:content) { should match /http\.cors\.allow-origin: "\*"/ }
  its(:content) { should match /http\.cors\.max-age: 86400/ }
  its(:content) { should match /http\.cors\.allow-methods: OPTIONS, HEAD, GET, POST, PUT, DELETE/ }
  its(:content) { should match /http\.cors\.allow-headers: X-Requested-With, Content-Type, Content-Length/ }
  its(:content) { should match /http\.cors\.allow-credentials: true/}

  it { should be_owned_by es_user_name }
  it { should be_grouped_into es_user_group }
  it { should be_mode 440 }
end

describe command("#{es_plugin_command} list") do
  its(:stdout) { should match /^\s+- hq/ }
  its(:stderr) { should eq ''}
  its(:exit_status) { should eq 0 }
end
