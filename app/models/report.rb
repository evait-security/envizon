class Report < ApplicationRecord
  has_many :report_parts, as: :reportable
  has_many :notes, as: :noteable

  def all_issues
    issue_array = []
    report_parts.each do |pt|
      pt.child_issues.each do |child|
        issue_array << child if child.type == 'Issue'
      end
    end
    issue_array
  end

  def self.prepare_text_docx(text) 
    text.gsub('<pre>', '<p>').gsub('</pre>', '</p>') if text
  end
end
