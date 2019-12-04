class ReportPart < ApplicationRecord
  belongs_to :reportable, polymorphic: true, optional: true
  has_many :screenshots, dependent: :destroy
  has_many :client_report_parts, foreign_key: :report_part_id
  has_many :clients, through: :client_report_parts


  def get_child_issues
    parts = []
    if self.type == "Issue"
      parts << self
    else
      report_parts.each do |pt|
        if pt.type == "Issue"
          parts << pt
        else
          pt.get_child_issues
        end
      end
    end
    return parts
  end
end