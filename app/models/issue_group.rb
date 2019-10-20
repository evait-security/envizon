class IssueGroup < ReportPart
  belongs_to :reportable, polymorphic: true, optional: true
  has_many :issues, as: :reportable
  has_many :issue_groups, as: :reportable
end
