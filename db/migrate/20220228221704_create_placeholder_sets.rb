class CreatePlaceholderSets < ActiveRecord::Migration[5.2]
  def change
    create_table :placeholder_sets do |t|
      t.string :name

      t.timestamps
    end
  end
end
