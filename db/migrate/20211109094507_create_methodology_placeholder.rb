class CreateMethodologyPlaceholder < ActiveRecord::Migration[5.2]
  def change
    create_table :methodology_placeholders do |t|
      t.references :methodology, foreign_key: true
      t.references :placeholder, foreign_key: true
    end
  end
end
