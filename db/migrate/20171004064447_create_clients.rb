class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :ip, limit: 39, default: ''
      t.string :mac, limit: 17, default: ''
      t.string :hostname, default: ''
      t.string :os, default: ''
      t.string :cpe, default: ''
      t.string :icon, default: ''
      t.string :vendor, default: ''
      t.string :ostype, default: ''

      t.timestamps
    end
  end
end
