class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.text :summary
      t.text :conclusion
      t.string :logo_url
      t.string :contact_person
      t.string :company_name
      t.string :street
      t.string :postalcode
      t.string :city

      t.timestamps
    end
  end
end
