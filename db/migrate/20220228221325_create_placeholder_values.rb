class CreatePlaceholderValues < ActiveRecord::Migration[5.2]
  def change
    create_table :placeholder_values do |t|
      t.string :content
      t.references :placeholder, foreign_key: true

      t.timestamps
    end
  end
end
