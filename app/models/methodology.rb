class Methodology < ApplicationRecord
  has_and_belongs_to_many :placeholders, join_table: :methodology_placeholders
  belongs_to :methodology_category
end
