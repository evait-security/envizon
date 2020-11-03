class IssueGroup < ReportPart
  belongs_to :reportable, polymorphic: true, optional: true
  has_many :report_parts, as: :reportable
  has_many :notes, as: :noteable
end
