class Report < ApplicationRecord
  has_many :issues, as: :reportable
  has_many :issue_groups, as: :reportable
end
