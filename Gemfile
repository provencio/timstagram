source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '>= 3.2.0'

gem 'rails', '~> 8.0.5', '>= 8.0.5.1'
# json 3.x drops the `quirks_mode` option that Rails 8.0's ActiveSupport JSON
# encoder still passes, which breaks every JSON-serialized column. 2.21.2 is the
# first 2.x release clear of all known json advisories.
gem 'json', '~> 2.21', '>= 2.21.2'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '>= 2.9.6'
# Use Puma as the app server
gem 'puma', '>= 8.0.2'

# Sprockets asset pipeline
gem 'sprockets-rails', '~> 3.5'
# Use SCSS for stylesheets
gem 'sassc-rails', '~> 2.1'
# Use Terser as compressor for JavaScript assets (Uglifier's UglifyJS 3 cannot
# parse the ES6 syntax that ships in Rails 8's rails-ujs).
gem 'terser', '>= 1.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Image variants for Active Storage attachments
gem 'image_processing', '~> 2.1'
gem 'ruby-vips', '>= 2.2'

gem 'simple_form', '~> 5.4'
gem 'haml', '~> 7.5'
gem 'devise', '>= 5.0.4'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.13'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'debugger' anywhere in the code to stop execution and get a debugger console
  gem 'debug', '>= 1.9', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.40'
  gem 'selenium-webdriver', '>= 4.14.0'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 4.2.0'
  gem 'listen', '~> 3.9'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
