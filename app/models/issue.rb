class Issue < ReportPart
  belongs_to :reportable, polymorphic: true
  has_and_belongs_to_many :clients
end
