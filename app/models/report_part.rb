class ReportPart < ApplicationRecord
  belongs_to :reportable, polymorphic: true, optional: true
  has_many :screenshots, dependent: :destroy
  has_many :client_report_parts, foreign_key: :report_part_id
  has_many :clients, through: :client_report_parts
end
