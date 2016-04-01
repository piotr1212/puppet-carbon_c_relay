require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    :concat_basedir            => '/nonexistant',
    :osfamily                  => 'Redhat',
    :operatingsystemmajrelease => '7',
  }
  c.after(:suite) do
    RSpec::Puppet::Coverage.report!
  end
end
