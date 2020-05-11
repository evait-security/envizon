class CreateSavedScansCollectionItems < ActiveRecord::Migration[5.2]
  def change
    create_table :saved_scans_collection_items do |t|
      t.references :saved_scans_collection, foreign_key: true
      t.references :saved_scan, foreign_key: true
      t.integer :order

      t.timestamps
    end
  end
end
