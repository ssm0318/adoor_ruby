source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'groupdate', '~> 4.1', '>= 4.1.1'
gem 'chartkick', '~> 3.0', '>= 3.0.2'
# gem 'errdo'
# gem 'log_analyzer'
gem 'active_model_serializers'
gem 'api-pagination'
gem 'figaro', '~> 1.1', '>= 1.1.1'
gem 'omniauth', '~> 1.9'
gem 'omniauth-kakao', :git => 'git://github.com/hcn1519/omniauth-kakao'
# gem 'omniauth-google-oauth2', '~> 0.4.1'
gem 'rubocop', '~> 0.63.1', require: false
gem 'rack-cors', :require => 'rack/cors'
gem 'jwt', '~> 2.1' # jwt.io
gem 'will_paginate', '~> 3.1', '>= 3.1.6'
gem 'friendly_id', '~> 5.2.4' # https://github.com/norman/friendly_id url을 예쁘게 (유저들이 자신의 ID를 볼 수 있는게 이상해서.)
gem 'rails_autolink', '~> 1.1', '>= 1.1.6'
gem 'autosize'
gem 'rails-i18n'
gem "i18n-js"
gem 'awesome_print', '~> 1.8'
gem 'ahoy_matey', '~> 2.2'
gem 'jquery-turbolinks'
gem 'active_link_to'
gem 'roo', '~> 2.7', '>= 2.7.1'
gem "rack", ">= 2.0.6"
gem 'whenever', require: false
gem 'jquery-rails'
gem 'rubyzip', ">= 1.2.2"
#gem "paperclip", "~> 6.1.0"
gem 'carrierwave', '~> 1.0'
gem 'mini_magick'
gem 'time_difference' 
gem 'devise'
gem 'simple_token_authentication', '~> 1.0'
gem 'pry-rails' 
gem 'rails_db'
gem 'rolify' #https://github.com/RolifyCommunity/rolify 
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', "~> 1.3.6"
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  # gem 'mailcatcher', '~> 0.6.1'
  gem 'faker', '~> 1.9', '>= 1.9.3'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
