class CreateSavedScans < ActiveRecord::Migration[5.1]
  def change
    create_table :saved_scans do |t|
      t.string :name
      t.string :parameter

      t.timestamps
    end
  end
end
