class CreateScans < ActiveRecord::Migration[5.1]
  def change
    create_table :scans do |t|
      t.string :command
      t.string :name
      t.datetime :startdate
      t.datetime :enddate
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
