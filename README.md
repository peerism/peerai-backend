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
  * [Chapter 5 - Setup Act As Tree Gem with Profile SkillToken Model](#chapter-5)
  * [Chapter 6 - Setup Closure Tree Gem with Profile SkillToken Model](#chapter-6)

## Chapter 0 - Usage
  * Install Ruby on Rails >5.1.3
  * Install dependencies
    ```
    bundle install
    ```
  * Run PostgreSQL
  * Create and Migrate the database
    ```
    bin/rails db:environment:set RAILS_ENV=development
    bundle exec rails db:drop db:create db:migrate db:seed
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
  * Remove the following from the Gemfile to prevent error `NameError: uninitialized constant SkillToken::ActsAsTree`
    ```
    # gem 'spring'
    # gem 'spring-watcher-listen', '~> 2.0.0'
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

## Chapter 5 - Setup Act As Tree Gem with Profile SkillToken Model<a id="chapter-5"></a>
  * Add Profile model
    ```
    bundle exec rails g model Profile user:references
    ```
  * Add associations to User
    ```
    has_one :profile, class_name: 'Profile'
    delegate :skill_tokens, :to => :profile
    ```
    * Reference: https://stackoverflow.com/questions/12606212/rails-3-has-many-through-has-one
  * Add associations to Profile
    ```
    belongs_to :user
    has_many :skill_tokens
    ```
  * Add Parent model for ActsAsTree
    ```
    bundle exec rails g model Parent
    ```
  * Add HABTM association to Parent model
    ```
    has_and_belongs_to_many :skill_tokens
    ```
  * Add SkillToken model with extra attribute `parent` for ActsAsTree
    ```
    bundle exec rails g model SkillToken name:string amount:decimal weight:decimal profile:references parent:references
    ```
  * Add ActsAsTree Gem to Gemfile
    ```
    gem 'acts_as_tree', '~> 2.7.0'
    ```
  * Add associations to SkillToken
    ```
    belongs_to :profile, class_name: 'Profile'
    ```
  * Add to SkillToken model. Ordered by name. [Customise ordering](https://github.com/ClosureTree/closure_tree#deterministic-ordering)
    ```
    belongs_to :profile, class_name: 'Profile'
    has_and_belongs_to_many :parents
    validates_presence_of :name

    extend ActsAsTree::TreeView
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
        * Run `bundle exec` as prefix before any `rails` command

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
    # show subchildren
    root.children.first.children
    ```
    * Note: Run the following if existing data previously added to the DB tables
      ```
      user1 = User.all.first
      user1.profile = Profile.all.first
      root = SkillToken.all.first
      root.children
      root.children.first.children
      ```
  * Note:
    * Error reported and solution - https://github.com/amerine/acts_as_tree/issues/71

## Chapter 6 - Setup Closure Tree Gem with Profile SkillToken Model<a id="chapter-6"></a>
  * Remove Conflicts - Delete ActsAsTaggableOn and ActsAsTree Gems since they cause conflicts.
  * Setup ClosureTree Gem
    ```
    https://github.com/ClosureTree/closure_tree#installation
    gem 'closure_tree', '~> 6.6.0'
    bundle install
    bundle exec rails g closure_tree:migration skill_token
    bin/rails db:environment:set RAILS_ENV=development
    bundle exec rails db:drop db:create db:migrate db:seed

    bundle exec rails c
    user1 = User.create(email: 'a@a.com', password: '12345678', encrypted_password: '12345678')
    user1.profile = Profile.create(user_id: user1.id)
    grandparent = SkillToken.create(name: 'Grandparent', weight: 1, profile_id: user1.profile.id)
    # verify the grandparent's parent is nil
    grandparent.parent
    # create parent root
    parent1 = Parent.create(id: 1)
    # create child parent
    parent = grandparent.children.create(name: 'Parent', weight: 1, profile_id: user1.profile.id, parent_id: parent1.id)
    # create parent of parent child
    parent2 = Parent.create(id: parent.id)
    # create child1 with root as parent
    child1 = parent.children.create(name: "child1", weight: 1, profile_id: user1.profile.id, parent_id: parent2.id)

    grandparent.self_and_descendants.collect(&:name)
    child1.ancestry_path

    parent3 = Parent.create(id: child1.id)

    # TBC
    child = SkillToken.find_or_create_by_path([
      {amount: '1', weight: '1', name: '2014', profile_id: user1.profile.id, parent_id: parent3.id},
      {amount: '1', weight: '1', name: 'August', profile_id: user1.profile.id, parent_id: parent3.id},
      {amount: '1', weight: '1', name: '5', profile_id: user1.profile.id, parent_id: parent3.id},
      {amount: '1', weight: '1', name: 'Visit the Getty Center', profile_id: user1.profile.id, parent_id: parent3.id}
    ])
    ```
