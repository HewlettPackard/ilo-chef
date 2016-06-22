# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require 'bundler'
require 'bundler/setup'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'

task default: :test

desc 'Run unit tests'
RSpec::Core::RakeTask.new(:unit) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = '--color '
end

desc 'Run unit tests for helper libraries only'
RSpec::Core::RakeTask.new('unit:libs') do |spec|
  spec.pattern = 'spec/unit/libraries/**/*_spec.rb'
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
