# README

---
Peer.ai Backend
---

# Table of Contents
  * [Chapter 0 - Usage](#chapter-0)
  * [Chapter 1 - Setup Ruby on Rails App](#chapter-1)
  * [Chapter 4 - Setup Act As Taggable Gem](#chapter-4)

## Chapter 0 - Usage
  * Install Ruby on Rails >5.1.3
  * Install dependencies
    ```
    bundle install
    ```
  * Run Guard
    ```
    bundle exec guard
    ```
  * Modify RSpec tests and code implementation

## Chapter 1 - Setup Ruby on Rails App <a id="chapter-1"></a>
  ```
  rails new --api peerai-backend --database=postgresql --skip-test
  ```


  ## Chapter 2 - Setup RSpec Gem and Guard RSpec Gem<a id="chapter-2"></a>
    * Reference: https://github.com/rspec/rspec-rails
    * Add to Gemfile
      ```
      gem 'rspec-rails', '~> 3.6'
      gem 'guard-rspec', require: false
      ```
    * Install dependencies
      ```
      bundle install
      ```
    * Setup RSpec directory
      ```
      bundle exec rails generate rspec:install
      ```
    * Generate empty Guardfile
      ```
      bundle exec guard init rspec
      ```
    * Customise Guardfile
      * Reference: https://github.com/guard/guard/wiki/Guardfile-DSL---Configuring-Guard
    * Run Guard
      ```
      bundle exec guard
      ```

  ## Chapter 3 - Setup Devise Gem<a id="chapter-3"></a>
    * Reference: https://github.com/plataformatec/devise
    * Add to Gemfile
      ```
      gem 'devise'
      ```
    * Install dependencies
      ```
      bundle install
      ```
    * Run Devise generator
      ```
      bundle exec rails g devise:install
      ```
    * Run tests
      ```
      bundle exec rspec
      ```
    * Add Generator configuration to application.rb.
      ```
      config.generators do |g|
        g.orm :active_record
        g.test_framework :rspec
      end
      ```
      * Reference: http://guides.rubyonrails.org/configuring.html
    * Generate Tests for User model
      ```
      bundle exec rails generate rspec:model User
      ```
    * Create Test Database
      ```
      bundle exec rails db:create db:migrate RAILS_ENV=test
      ```
    * Run tests
      ```
      bundle exec rspec
      ```
    * Generate User model
      ```
      bundle exec rails generate devise User
      ```
    * Migrate Devise User into database
      ```
      bundle exec rails db:migrate RAILS_ENV=test
      ```
    * Run tests
    * Generate Custom Devise Controllers
      ```
      bundle exec rails generate devise:controllers user
      ```
    * Override routes in routes.rb
      ```
      devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
      }
      ```
    * Add requirement for authentication in application_controller.rb
      ```
      before_action :authenticate_user!
      ```
    * Uncomment the following in rails_helper.rb
      ```
      Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
      ```
    * Add to spec/support/devise.rb
      ```
      require 'devise'
      require 'support/factory_bot'
      require_relative 'support/controller_macros'
      RSpec.configure do |config|
        config.include Devise::TestHelpers, :type => :controller
      end
      ```
    * Add ControllerMacros
      * Reference: https://github.com/plataformatec/devise/wiki/How-To:-Test-controllers-with-Rails-3-and-4-(and-RSpec)
    * Add controller tests
      ```
      bundle exec rails g rspec:controller application
      ```
    * Add FactoryBotRails
      ```
      gem 'factory_bot_rails', '~> 4.0'
      ```
      * Reference: https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#configure-your-test-suite
    * Add to spec/support/factory_bot.rb
      ```
      RSpec.configure do |config|
        config.include FactoryBot::Syntax::Methods
      end
      ```
    * Add to spec/factories/user.rb
      ```
      FactoryBot.define do
        factory :user do
          email "ltfschoen@gmail.com"
          password "12345678"
        end
      end
      ```
    * Add to spec/factories/user.rb
      * Reference: https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#configure-your-test-suite
    * Run tests

## Chapter 4 - Setup Act As Taggable Gem<a id="chapter-4"></a>
  * Reference: https://github.com/mbleigh/acts-as-taggable-on
  * Add to Gemfile
    ```
    gem 'acts-as-taggable-on', '~> 4.0'`
    ```
  * Install dependency
    ```sh
    bundle install
    ```
  * Generate migration files in db/migrate
    ```sh
    rails acts_as_taggable_on_engine:install:migrations
  * Run PostgreSQL server
  * Migrate migrations into PostgreSQL tables
    rails db:migrate
    ```
>>>>>>> 8125c11... feat: Add ActAsTaggableOn Gem and migrations
