class CreateJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :groups, :clients do |t|
      # t.index [:group_id, :client_id]
      # t.index [:client_id, :group_id]
    end
  end
end
