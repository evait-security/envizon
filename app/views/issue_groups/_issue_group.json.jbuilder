json.extract! issue_group, :id, :title, :severity, :description, :customtargets, :rating, :recommendation, :type, :index, :created_at, :updated_at
json.url issue_group_url(issue_group, format: :json)
