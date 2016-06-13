require 'bundler'
require 'bundler/setup'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'

task default: :test

desc 'Run unit tests only'
RSpec::Core::RakeTask.new(:unit) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = '--color '
end

RuboCop::RakeTask.new do |task|
  task.options << '--display-cop-names'
end

desc 'Run cookbook lint tool'
FoodCritic::Rake::LintTask.new(:foodcritic) do |t|
  t.options = {
    fail_tags: ['any']
  }
end

desc 'Runs all style checks'
task style: [:rubocop, :foodcritic]

desc 'Runs all style, unit, and integration tests'
task test: [:style, :unit]
