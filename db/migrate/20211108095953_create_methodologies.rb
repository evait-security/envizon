class CreateMethodologies < ActiveRecord::Migration[5.2]
  def change
    create_table :methodologies do |t|
      t.string :name
      t.string :title
      t.string :author
      t.string :category
      t.text :refs
      t.text :content

      t.timestamps
    end
  end
end
