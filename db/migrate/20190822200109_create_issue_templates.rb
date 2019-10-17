class CreateIssueTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :issue_templates do |t|
      t.string :title
      t.text :description
      t.text :rating
      t.text :recommendation
      t.integer :severity

      t.timestamps
    end
  end
end
