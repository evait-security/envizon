json.extract! report, :id, :summary, :conclusion, :logo_url, :contact_person, :company_name, :street, :postalcode, :city, :title, :created_at, :updated_at
json.url report_url(report, format: :json)
