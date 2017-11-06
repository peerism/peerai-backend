class Parent < ApplicationRecord
  # has_many :skill_tokens
  has_and_belongs_to_many :skill_tokens
end
