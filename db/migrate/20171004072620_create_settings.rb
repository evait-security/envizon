class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.string :name
      t.string :value
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
