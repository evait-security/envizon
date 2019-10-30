json.extract! report_part, :id, :title, :severity, :description, :customtargets, :rating, :recommendation, :type, :index, :created_at, :updated_at
json.url report_part_url(report_part, format: :json)
