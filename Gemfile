source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

gem 'workarea', github: 'workarea-commerce/workarea', branch: :master

group :test do
  gem 'simplecov', require: false
  gem 'workarea-oms', github: 'workarea-commerce/workarea-oms', branch: :master
end
