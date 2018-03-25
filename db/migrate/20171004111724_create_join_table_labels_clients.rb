class CreateJoinTableLabelsClients < ActiveRecord::Migration[5.1]
  def change
    create_join_table :labels, :clients do |t|
      # t.index [:label_id, :client_id]
      # t.index [:client_id, :label_id]
    end
  end
end
