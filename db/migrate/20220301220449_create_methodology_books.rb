class CreateMethodologyBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :methodology_books do |t|
      t.string :name

      t.timestamps
    end
  end
end
