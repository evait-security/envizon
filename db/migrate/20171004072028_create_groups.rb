class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :name, default: ''
      t.string :icon, default: ''
      t.boolean :mod

      t.timestamps
    end
  end
end
