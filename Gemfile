source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

gem 'workarea', github: 'workarea-commerce/workarea', branch: 'v3.4-stable'
gem 'byebug'

group :test do
  gem 'simplecov', require: false
  gem 'workarea-oms', source: "https://gems.weblinc.com"
  gem 'workarea-testing', '>= 3.2.0', source: 'https://gems.weblinc.com'
end
