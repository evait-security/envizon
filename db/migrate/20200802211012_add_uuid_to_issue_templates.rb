class AddUuidToIssueTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :issue_templates, :uuid, :integer, default: 0
  end
end
