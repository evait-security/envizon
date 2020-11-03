class ReportPart < ApplicationRecord
  belongs_to :reportable, polymorphic: true, optional: true
  has_many :screenshots, dependent: :destroy
  has_many :client_report_parts, foreign_key: :report_part_id
  has_many :clients, through: :client_report_parts
  has_many :notes, as: :noteable

  def child_issues
    return [self] if type == 'Issue'

    report_parts.map do |pt|
      if pt.type == 'Issue'
        pt
      else
        pt.child_issues
      end
    end.flatten.compact
  end

  def ordered_child_issues
    return [self] if type == 'Issue'
    
    report_parts.order(:index).map do |pt|
      if pt.type == 'Issue'
        pt
      else
        pt.child_issues
      end
    end.flatten.compact
  end

end
