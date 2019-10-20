class ReportPart < ApplicationRecord
  belongs_to :reportable, polymorphic: true, optional: true
end
