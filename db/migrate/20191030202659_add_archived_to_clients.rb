class AddArchivedToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :archived, :boolean, default: false
  end
end
