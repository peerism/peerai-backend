class ActsAsTree < ApplicationRecord
  belongs_to :parent_id
end
