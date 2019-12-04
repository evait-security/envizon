source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# nmap
gem 'ruby-nmap', git: 'https://github.com/sophsec/ruby-nmap.git'

# Icon-Pack
# Use Material Icons directly without gem. Gem maintailer not update the gem frequently
# gem 'material_icons', git: 'https://github.com/Angelmmiguel/material_icons'

# Login
gem 'devise'

# Form
gem 'materialize-form'
gem 'simple_form'

# fix multipart upload not rendering js
gem 'remotipart'

# Frontend
# gem 'devise-bootstrap-views'
gem 'font-awesome-rails'
gem 'jquery-datatables-rails'
gem 'jquery-ui-rails'
gem 'materialize-sass'

# screenshots
gem 'selenium-webdriver'
gem 'image_processing'

# jobs
# (maybe use sidekiq or whatever in prod?)
# (redis would be used for ActionCable anyway, so..)
gem 'sucker_punch'
gem 'sidekiq'

# db import/export
gem 'yaml_db', git: 'https://github.com/evs-ch/yaml_db.git'
gem 'activerecord-import'

# zip
gem 'rubyzip', '>= 1.0.0' # will load new rubyzip version
gem 'zip-zip' # will load compatibility for old rubyzip API.

# export report
gem 'sablon' # docx tamplate

# gdrive plugin to backup issue database
gem 'google_drive'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'irb'
  # Adds support for Capybara system testing and selenium driver
  gem 'brakeman'
  gem 'capybara', '~> 2.13'
  gem 'coverband', git: 'https://github.com/represent/coverband.git'
  gem 'minitest-rails'
  gem 'minitest-reporters'
  gem 'pry'
  gem 'pry-rails'
  gem 'railroady'
  gem 'rails-erd'
  gem 'rails_best_practices'
  gem 'rake'
  gem 'rubocop'
end

group :development do

  # documentation
  gem 'jeweler'
  gem 'redcarpet'
  gem 'yard', '>= 0.9.12'
  gem 'yard-restful', git: 'https://github.com/evs-ch/yard-restful.git'

  gem 'web-console'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  # gem 'web-console'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # find unused code..
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
