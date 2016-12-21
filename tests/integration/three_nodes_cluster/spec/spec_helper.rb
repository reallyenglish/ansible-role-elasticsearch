require 'infrataster/rspec'
require 'infrataster-plugin-firewall'

ENV['VAGRANT_CWD'] = File.dirname(__FILE__)
ENV['LANG'] = 'C'

Infrataster::Server.define(
  :es1,
  '192.168.21.101',
  vagrant: true,
)

Infrataster::Server.define(
  :es2,
  '192.168.21.102',
  vagrant: true,
)

Infrataster::Server.define(
  :es3,
  '192.168.21.103',
  vagrant: true,
)

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'default'
end
