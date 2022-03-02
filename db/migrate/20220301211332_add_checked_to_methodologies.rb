class AddCheckedToMethodologies < ActiveRecord::Migration[5.2]
  def change
    add_column :methodologies, :checked, :boolean, default: false
  end
end
