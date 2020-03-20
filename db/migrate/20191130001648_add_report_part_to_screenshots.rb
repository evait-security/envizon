class AddReportPartToScreenshots < ActiveRecord::Migration[5.2]
  def change
    add_reference :screenshots, :report_part, foreign_key: true
  end
end
