source 'https://rubygems.org'

gem 'chef', '~> 12.5'
gem 'chefspec'
case RUBY_VERSION
when /^2\.[01]/
  gem 'berkshelf', '~> 4.3' # Use older version of berkshelf for Ruby 2.0 and 2.1
  # This is necessary because berkshelf 5.0 requires buff-extensions 2.0.0, which requires Ruby >= 2.2
  gem 'chef-zero', '~> 4.0' # Use older version of chef-zero for Ruby 2.0 and 2.1
  # This is necessary because chef-zero 5.0 requires requires Ruby >= 2.2.2
when /^2\.2\.[01]/
  gem 'chef-zero', '~> 4.0' # Use older version of chef-zero for Ruby 2.2.0 and 2.2.1
else
  gem 'berkshelf'
end
gem 'foodcritic'
gem 'rubocop', '= 0.42.0'
gem 'ilo-sdk'
gem 'pry'
