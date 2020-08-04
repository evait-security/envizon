class AddUuidToReportParts < ActiveRecord::Migration[5.2]
  def change
    add_column :report_parts, :uuid, :integer, default: 0
  end
end
