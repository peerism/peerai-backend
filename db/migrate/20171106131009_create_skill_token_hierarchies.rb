class CreateSkillTokenHierarchies < ActiveRecord::Migration[5.1]
  def change
    create_table :skill_token_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :skill_token_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "skill_token_anc_desc_idx"

    add_index :skill_token_hierarchies, [:descendant_id],
      name: "skill_token_desc_idx"
  end
end
