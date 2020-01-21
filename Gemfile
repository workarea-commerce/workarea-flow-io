source 'https://rubygems.org'

git_source :github do |repo|
  if ENV['GITHUB_TOKEN']
    "https://x-access-token:#{ENV['GITHUB_TOKEN']}@github.com/#{repo}.git"
  else
    "https://github.com/#{repo}.git"
  end
end

gemspec

gem 'byebug'
gem 'simplecov', require: false
gem 'sprockets', '~> 3'

source 'https://gems.weblinc.com' do
  gem 'workarea-oms', '~> 5.1.1'
end
