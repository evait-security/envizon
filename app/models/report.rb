class Report < ApplicationRecord
  has_many :report_parts, as: :reportable
end
