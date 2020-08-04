class DropSavedScansCollections < ActiveRecord::Migration[5.2]
  def up
    drop_table :saved_scans_collections
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
