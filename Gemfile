source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'devise'

# JSON Serializer
gem 'active_model_serializers', git: 'git@github.com:rails-api/active_model_serializers.git', branch: '0-8-stable'

# pagination
gem 'kaminari'

# Background Jobs
gem 'delayed_job_active_record'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :test, :development do
  gem 'factory_girl_rails'
  gem 'ffaker'
end

group :test do
  gem 'rspec-rails'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  #Improve unit tests
  gem 'shoulda-matchers'
  # Mailer tests
  gem 'email_spec'
end 

group :development, :test do
  #MySQL gem
  gem 'mysql2'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

