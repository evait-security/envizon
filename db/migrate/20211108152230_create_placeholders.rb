class CreatePlaceholders < ActiveRecord::Migration[5.2]
  def change
    create_table :placeholders do |t|
      t.string :name

      t.timestamps
    end
  end
end
