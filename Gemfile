source 'https://rubygems.org'

case RUBY_VERSION
when /^2\.0/
  gem 'chef', '~> 12.5', '< 12.9'
  gem 'berkshelf', '~> 4.3'
when /^2\.1/
  gem 'chef', '~> 12.5', '< 12.14'
  gem 'berkshelf', '~> 4.3'
when /^2\.2\.[01]/
  gem 'chef', '~> 12.5', '< 12.14'
  gem 'berkshelf'
else
  gem 'chef', '~> 12.5'
  gem 'berkshelf'
end
gem 'chefspec'
gem 'foodcritic'
gem 'rubocop', '= 0.42.0'
gem 'ilo-sdk'
gem 'pry'
