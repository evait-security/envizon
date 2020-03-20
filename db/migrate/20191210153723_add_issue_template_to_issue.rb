class AddIssueTemplateToIssue < ActiveRecord::Migration[5.2]
  def change
    add_reference :report_parts, :issue_template, foreign_key: true, null: true
  end
end
