class AddColumnToScans < ActiveRecord::Migration[5.1]
  def change
    add_column :scans, :file, :string
  end
end
