class CreateSkillTokenParents < ActiveRecord::Migration[5.1]
  def change
    create_table :skill_token_parents, id: false do |t|
      t.belongs_to :skill_token, index: true
      t.belongs_to :parent, index: true
    end
  end
end
