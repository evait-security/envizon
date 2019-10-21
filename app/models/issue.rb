class Issue < ReportPart
  belongs_to :reportable, polymorphic: true
end
