class CreateSkillTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :skill_tokens do |t|
      t.string :name
      t.decimal :amount
      t.decimal :weight
      t.references :parent, foreign_key: true
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
