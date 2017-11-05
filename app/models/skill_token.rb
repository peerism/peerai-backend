class SkillToken < ActiveRecord::Base
  belongs_to :profile, class_name: 'UserProfile'
  belongs_to :parent
  validates_presence_of :name

  extend ActsAsTree::TreeView
  acts_as_tree order: 'name'
end
