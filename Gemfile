source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :test do
  gem 'rspec-core',                                    :require => false
  gem 'puppetlabs_spec_helper',                        :require => false
  gem 'simplecov',                                     :require => false
  gem 'puppet_facts',                                  :require => false
  gem 'json',                                          :require => false
  gem 'metadata-json-lint',                            :require => false
  gem 'puppet-lint-duplicate_class_parameters-check',  :require => false
end

group :development do
  gem 'guard-rake',      :require => false
  gem 'puppet-strings',  :require => false
  gem 'redcarpet',       :require => false
end


if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# vim:ft=ruby
