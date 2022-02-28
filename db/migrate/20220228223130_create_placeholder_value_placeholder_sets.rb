class CreatePlaceholderValuePlaceholderSets < ActiveRecord::Migration[5.2]
  def change
    create_table :placeholder_v_placeholder_s do |t|
      t.references :placeholder_value, foreign_key: true
      t.references :placeholder_set, foreign_key: true
    end
  end
end
