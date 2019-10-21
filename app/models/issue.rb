class Issue < ReportPart
  belongs_to :reportable, polymorphic: true
  has_many :client_report_parts, foreign_key: :report_part_id
  has_many :clients, through: :client_report_parts
end
