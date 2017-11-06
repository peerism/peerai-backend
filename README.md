# README

---
Peer.ai Backend
---

# Table of Contents
  * [Chapter 0 - Usage](#chapter-0)
  * [Chapter 1 - Setup Ruby on Rails App](#chapter-1)
  * [Chapter 2 - Setup RSpec Gem and Guard RSpec Gem](#chapter-2)
  * [Chapter 3 - Setup Devise Gem](#chapter-3)
  * [Chapter 4 - Setup Act As Taggable Gem](#chapter-4)
  * [Chapter 5 - Setup Act As Tree Gem with UserProfile SkillToken Model](#chapter-5)

## Chapter 0 - Usage
  * Install Ruby on Rails >5.1.3
  * Install dependencies
    ```
    bundle install
    ```
  * Run PostgreSQL
  * Create and Migrate the database
    ```
    bundle exec rails db:drop db:create db:migrate
    ```
  * Run Guard
    ```
    bundle exec guard
    ```
  * Run API Server
    ```
    bundle exec rails s
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
    ```
    * Add Fixes - https://github.com/mbleigh/acts-as-taggable-on/issues/845
  * Run PostgreSQL server
  * Migrate migrations into PostgreSQL tables
    rails db:migrate
    ```

## Chapter 5 - Setup Act As Tree Gem with UserProfile SkillToken Model<a id="chapter-5"></a>
  * Add UserProfile model
    ```
    bundle exec rails g model UserProfile user:references
    ```
  * Add associations to User
    ```
    has_one :profile, class_name: 'UserProfile'
    delegate :skill_tokens, :to => :profile
    ```
    * Reference: https://stackoverflow.com/questions/12606212/rails-3-has-many-through-has-one
  * Add associations to UserProfile
    ```
    belongs_to :user
    has_many :skill_tokens
    ```
  * Add Parent model for ActsAsTree
    ```
    bundle exec rails g model Parent
    ```
  * Add association to Parent model
    ```
    has_many :skill_tokens
    ```
  * Add SkillToken model
    ```
    bundle exec rails g model SkillToken name:string amount:decimal weight:decimal user_profile:references
    ```
  * Add extra attribute to SkillToken model for ActsAsTree
    ```
    t.references :parent, foreign_key: true
    ```
  * Add ActsAsTree Gem to Gemfile
    ```
    gem 'acts_as_tree', '~> 2.7.0'
    ```
  * Add associations to SkillToken
    ```
    belongs_to :profile, class_name: 'UserProfile'
    ```
  * Add to SkillToken model
    ```
    acts_as_tree order: 'name'
    ```
  * Migrate database
    ```
    bundle exec rails db:drop db:create db:migrate
    ```
  * Run rails
    ```
    bundle exec rails s
    ```
    * Troubleshooting
      * Problem
        ```
        $ rails s
        Could not find bcrypt-3.1.11 in any of the sources
        Run `bundle install` to install missing gems.
        ```
      * Solution
        * Uncomment in Gemfile `gem 'bcrypt', '~> 3.1.11'`
        * Run `gem pristine bcrypt --version 3.1.11`
        * Run `bundle exec rails s`
  * Rails console
    ```
    bundle exec rails c

    # create user and profile
    user1 = User.create(email: 'a@a.com', password: '12345678', encrypted_password: '12345678')
    user1.profile = Profile.create(user_id: user1.id)
    # create root
    root = SkillToken.create(name: "root", weight: 1, profile_id: user1.profile.id)
    # verify that root's parent is nil
    root.parent
    # show the Tree View
    SkillToken.tree_view(:name)
    # create parent root
    parent1 = Parent.create(id: 1)
    # create child1 with root as parent
    child1 = root.children.create(name: "child1", weight: 1, profile_id: user1.profile.id, parent_id: parent1.id)
    # create parent of sub-child
    parent2 = Parent.create(id: child1.id)
    # create sub-child1 of child1
    subchild1 = child1.children.create(name: "subchild1", weight: 1, profile_id: user1.profile.id, parent_id: child1.id)
    # show parents
    Parent.all
    # create sub-child2 of child1
    subchild2 = child1.children.create(name: "subchild2", weight: 1, profile_id: user1.profile.id, parent_id: child1.id)
    # show the Tree View
    SkillToken.tree_view(:name)
    # |_ root
    #   |_ child1
    #     |_ subchild1
    #     |_ subchild2
    ```
  * Note:
    * Error occurs - https://github.com/amerine/acts_as_tree/issues/71
