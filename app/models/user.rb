class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :profile, class_name: 'Profile'
  # has_many :skill_tokens, :through => :profile
  delegate :skill_tokens, :to => :profile
end
