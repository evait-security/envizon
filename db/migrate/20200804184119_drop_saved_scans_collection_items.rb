class DropSavedScansCollectionItems < ActiveRecord::Migration[5.2]
  def up
    remove_reference :saved_scans_collection_items, :saved_scans_collection, foreign_key: true
    remove_reference :saved_scans_collection_items, :saved_scan, foreign_key: true
    drop_table :saved_scans_collection_items
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
