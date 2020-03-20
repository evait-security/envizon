class CreateClientReportParts < ActiveRecord::Migration[5.2]
  def change
    create_table :client_report_parts do |t|
      t.references :report_part, foreign_key: true
      t.references :client, foreign_key: true
    end
  end
end
