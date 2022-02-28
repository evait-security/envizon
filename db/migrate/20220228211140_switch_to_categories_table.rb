class SwitchToCategoriesTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :methodologies, :category
  end
end
