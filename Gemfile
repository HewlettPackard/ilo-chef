source 'https://rubygems.org'

gem 'chef', '~> 12.5'
gem 'chefspec'
if RUBY_VERSION =~ /^2\.[01]/
  gem 'berkshelf', '~> 4.3' # Use older version of berkshelf for Ruby 2.0 and 2.1
  # This is necessary because berkshelf 5.0 requires buff-extensions 2.0.0, which requires Ruby >= 2.2
else
  gem 'berkshelf'
end
gem 'foodcritic'
gem 'rubocop', '= 0.42.0'
gem 'ilo-sdk'
gem 'pry'
