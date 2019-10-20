class ReportPart < ApplicationRecord
  belongs_to :reportable, polymorphic: true, optional: true
  has_many :screenshots, dependent: :destroy
end
