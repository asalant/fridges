source 'http://rubygems.org'

gem 'rails', '3.0.0'
gem 'haml'
gem "haml-rails"
gem 'json'
gem 'paperclip'
gem 'aws-s3'
gem 'devise', :git => "http://github.com/plataformatec/devise.git"
gem 'oauth2'
gem 'hoptoad_notifier'

group :production do
  gem "pg"
end

group :development do
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'heroku'
  gem 'taps'
  gem 'hpricot'
  gem 'ruby_parser'
end

group :test do
  gem 'rspec_tag_matchers'
  gem 'mocha'
end

group :test, :development do
  gem 'rspec-rails', '>= 2.0.0.beta.20'
end
