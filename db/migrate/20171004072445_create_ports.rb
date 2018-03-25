class CreatePorts < ActiveRecord::Migration[5.1]
  def change
    create_table :ports do |t|
      t.references :client, foreign_key: true
      t.integer :number, limit: 5, default: -1
      t.string :service, default: ''
      t.text :description
      t.boolean :sv, default: false

      t.timestamps
    end
  end
end
