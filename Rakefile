require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

exclude_paths = [
  "templates/**/*.epp",
]
PuppetSyntax.exclude_paths = exclude_paths

Rake::Task[:lint].clear

PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = exclude_paths
  config.fail_on_warnings = false
  config.disable_checks = [
    'autoloader_layout',
    'class_parameter_defaults',
    'class_inherits_from_params_class',
    '80chars'
  ]
end