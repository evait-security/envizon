class CreateSavedScansCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :saved_scans_collections do |t|
      t.string :name

      t.timestamps
    end
  end
end
