class CreateReportParts < ActiveRecord::Migration[5.2]
  def change
    create_table :report_parts do |t|
      t.string :title
      t.integer :severity
      t.text :description
      t.text :customtargets
      t.text :rating
      t.text :recommendation
      t.string :type
      t.integer :reportable_id
      t.string :reportable_type

      t.timestamps
    end
  end
end
