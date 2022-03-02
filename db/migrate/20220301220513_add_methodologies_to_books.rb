class AddMethodologiesToBooks < ActiveRecord::Migration[5.2]
  def change
    add_reference :methodologies, :methodology_book, null: true, foreign_key: true
  end
end
