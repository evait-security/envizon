class AddMethodologyCategoryToMethodologies < ActiveRecord::Migration[5.2]
  def change
    add_reference :methodologies, :methodology_category, null: true, foreign_key: true
  end
end
