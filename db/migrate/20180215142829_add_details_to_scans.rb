class AddDetailsToScans < ActiveRecord::Migration[5.1]
  def change
    add_column :scans, :status, :int
  end
end
