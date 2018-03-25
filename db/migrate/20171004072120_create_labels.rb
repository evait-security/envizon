class CreateLabels < ActiveRecord::Migration[5.1]
  def change
    create_table :labels do |t|
      t.string :name, default: ''
      t.text :description, default: ''
      t.string :priority, default: ''

      t.timestamps
    end
  end
end
