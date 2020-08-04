class RemoveIssueTemplatesFromReportParts < ActiveRecord::Migration[5.2]
  def change
    remove_reference :report_parts, :issue_template, foreign_key: true
  end
end
