require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-strings/rake_tasks'

Rake::Task[:lint].clear

PuppetLint::RakeTask.new :lint do |config|
  config.fail_on_warnings = false
  config.disable_checks = [
    'autoloader_layout',
    'class_parameter_defaults',
    'class_inherits_from_params_class',
    '80chars'
  ]
end
