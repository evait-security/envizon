class AddIndexToReportParts < ActiveRecord::Migration[5.2]
  def change
    add_column :report_parts, :index, :integer
  end
end
