json.extract! issue, :id, :title, :severity, :description, :customtargets, :rating, :recommendation, :type, :index, :created_at, :updated_at
json.url issue_url(issue, format: :json)
