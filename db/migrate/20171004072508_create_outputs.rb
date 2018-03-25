class CreateOutputs < ActiveRecord::Migration[5.1]
  def change
    create_table :outputs do |t|
      t.references :client, foreign_key: true
      t.references :port, foreign_key: true
      t.string :name, default: ''
      t.string :value, default: ''

      t.timestamps
    end
  end
end
