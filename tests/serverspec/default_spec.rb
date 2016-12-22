require 'spec_helper'
require 'serverspec'

es_package_name = 'elasticsearch'
es_service_name = 'elasticsearch'
es_config_path  = '/etc/elasticsearch'
es_user_name    = 'elasticsearch'
es_user_group   = 'elasticsearch'

es_plugin_command = '/usr/share/elasticsearch/bin/plugin'
es_plugins_directory = '/usr/share/elasticsearch/plugins'

case os[:family]
when 'freebsd'
  es_package_name = 'elasticsearch2'
  es_config_path = '/usr/local/etc/elasticsearch'
  es_plugin_command = '/usr/local/bin/elasticsearch-plugin'
  es_plugins_directory = '/usr/local/lib/elasticsearch/plugins'
when "openbsd"
  es_user_name = "_elasticsearch"
  es_user_group = "_elasticsearch"
  es_plugin_command = "/usr/local/elasticsearch/bin/plugin"
  es_plugins_directory = "/usr/local/elasticsearch/plugins"
end

describe service(es_service_name) do
  it { should be_running }
end

describe package(es_package_name) do
  it { should be_installed }
end 

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/elasticsearch") do
    it { should be_file }
    its(:content) { should match(Regexp.escape('JAVA_OPTS="-XX:+UseCompressedOops"')) }
  end

#  XXX `process` does not support FreeBSD's `ps(1)`
#
#  describe process("/usr/local/openjdk8/bin/java") do
#    it { should be_running }
#    its(:args) { should match(Regexp.escape("-XX:+UseCompressedOops")) }
#  end
  describe command("ps axww") do
    its(:stdout) { should match(/#{ Regexp.escape("/usr/local/openjdk8/bin/java") }\s+.*#{ Regexp.escape("-XX:+UseCompressedOops") }/) }
  end
when "ubuntu"
  describe file("/etc/default/elasticsearch") do
    it { should be_file }
    its(:content) { should match(/^ES_JAVA_OPTS=\"#{ Regexp.escape("-XX:+UseCompressedOops") }\"$/) }
  end

  describe process("java") do
    it { should be_running }
    its(:args) { should match(Regexp.escape("-XX:+UseCompressedOops")) }
  end
when "redhat"
  describe file("/etc/sysconfig/elasticsearch") do
    it { should be_file }
    its(:content) { should match(/^ES_JAVA_OPTS=\"#{ Regexp.escape("-XX:+UseCompressedOops") }\"$/) }
  end

  describe process("java") do
    it { should be_running }
    its(:args) { should match(Regexp.escape("-XX:+UseCompressedOops")) }
  end
when "openbsd"
  describe file("/etc/elasticsearch/jvm.in") do
    it { should be_file }
    its(:content) { should match(/JAVA_OPTS=\"#{ Regexp.escape("-XX:+UseCompressedOops") }\"$/) }
  end

  # XXX same issue as FreeBSD
  # -Xms257m -Xmx1024m
  describe command("ps axww") do
    its(:stdout) { should match(/#{ Regexp.escape("/usr/local/jdk-1.8.0/bin/java") }\s+.*#{ Regexp.escape("-XX:+UseCompressedOops") }/) }
    its(:stdout) { should match(/#{ Regexp.escape("/usr/local/jdk-1.8.0/bin/java") }\s+.*#{ Regexp.escape("-Xms257m") }/) }
    its(:stdout) { should match(/#{ Regexp.escape("/usr/local/jdk-1.8.0/bin/java") }\s+.*#{ Regexp.escape("-Xmx1024m") }/) }
  end
end

[ 9200, 9300 ].each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

describe file("#{ es_config_path }/elasticsearch.yml") do
  its(:content_as_yaml) { should include("cluster.name" => "testcluster") }
  its(:content_as_yaml) { should include("node.name" => "testnode") }
  its(:content_as_yaml) { should include("discovery.zen.ping.multicast.enabled" => "false") }
  its(:content_as_yaml) { should include("discovery.zen.ping.unicast.hosts" => [ "10.0.2.15" ]) }
  its(:content_as_yaml) { should include("network.publish_host" => [ "10.0.2.15" ]) }
  its(:content_as_yaml) { should include("http.cors.enabled" => "true") }
  its(:content_as_yaml) { should include("http.cors.allow-origin" => "*") }
  its(:content_as_yaml) { should include("http.cors.max-age" => 86400) }
  its(:content_as_yaml) { should include("http.cors.allow-methods" => "OPTIONS, HEAD, GET, POST, PUT, DELETE") }
  its(:content_as_yaml) { should include("http.cors.allow-headers" => "X-Requested-With, Content-Type, Content-Length") }
  its(:content_as_yaml) { should include("http.cors.allow-credentials" => "true") }

  it { should be_owned_by es_user_name }
  it { should be_grouped_into es_user_group }
  it { should be_mode 440 }
end

describe file(es_plugins_directory) do
  it { should be_directory }
end

describe command("#{es_plugin_command} list") do
  its(:stdout) { should match /^\s+- hq/ }
  its(:stderr) { should eq ''}
  its(:exit_status) { should eq 0 }
end
