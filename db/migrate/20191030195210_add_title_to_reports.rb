class AddTitleToReports < ActiveRecord::Migration[5.2]
  def change
    add_column :reports, :title, :string
  end
end
