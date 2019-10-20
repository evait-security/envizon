class IssueGroup < ReportPart
  belongs_to :reportable, polymorphic: true, optional: true
  has_many :report_parts, as: :reportable
end
