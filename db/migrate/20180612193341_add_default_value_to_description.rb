class AddDefaultValueToDescription < ActiveRecord::Migration[5.1]
  def change
    change_column :ports, :description, :text, default: ""
  end
end
