class CreateParents < ActiveRecord::Migration[5.1]
  def change
    create_table :parents do |t|

      t.timestamps
    end
  end
end
