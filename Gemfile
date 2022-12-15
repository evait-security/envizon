source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.1.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 7.0", ">= 7.0.2.3"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.2'
# Use Puma as the app server
gem 'puma', '~> 5.0'

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Use SCSS for stylesheets
# gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
# gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
# gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
gem 'redis', '~> 3.3', '>= 3.3.1'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# nmap
gem 'ruby-nmap', git: 'https://github.com/postmodern/ruby-nmap.git'
gem 'ipaddress', git: 'https://github.com/ipaddress-gem/ipaddress.git'

# psych > 4 needed
# gem 'psych', '~> 4.0', '>= 4.0.1'

# Login
gem 'devise'

# Form
gem 'simple_form'

# fix multipart upload not rendering js
gem 'remotipart'

# Frontend
# gem 'devise-bootstrap-views'
# gem 'font_awesome5_rails'
# gem 'jquery-datatables-rails'
# gem 'jquery-ui-rails'
# gem 'toastr_rails'

# bootstrap
# gem 'bootstrap', git:"https://github.com/twbs/bootstrap-rubygem"

# diff
gem 'diffy'

# screenshots
gem 'image_processing'
gem 'mini_magick'
gem 'selenium-webdriver'

# jobs
gem 'sidekiq'
gem 'foreman'

# gems needed for sidekiq, not bundled in Ruby 2.7 anymore
gem 'e2mmap'
gem 'thwait'

# db import/export
gem 'down'
gem 'mysql2'

# zip
gem 'rubyzip', '>= 1.0.0' # will load new rubyzip version
gem 'zip-zip' # will load compatibility for old rubyzip API.

# export report
gem 'axlsx' # xlsx export
gem 'sablon' # docx tamplate

gem 'avo'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'irb'
  # Adds support for Capybara system testing and selenium driver
  gem 'brakeman'
  gem 'capybara'
  # gem 'minitest-rails'
  # gem 'minitest-reporters'
  gem 'pry'
  gem 'pry-rails'
  gem 'railroady'
  gem 'rails_best_practices'
  gem 'rails-erd'
  gem 'rake'
  gem 'rubocop'
end

group :development do

  # documentation
  gem 'jeweler'
  gem 'redcarpet'
  gem 'yard', '>= 0.9.12'
  # gem 'yard-restful', git: 'https://github.com/evs-ch/yard-restful.git'

  gem 'web-console'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  # gem 'web-console'
  # gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
  # find unused code..
end
