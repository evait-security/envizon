class Screenshot < ApplicationRecord
  belongs_to :report_part
  has_one_attached :image
end
