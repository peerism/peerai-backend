class UserProfile < ApplicationRecord
  belongs_to :user
  has_many :skill_tokens
end
