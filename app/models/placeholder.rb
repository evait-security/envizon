class Placeholder < ApplicationRecord
  has_and_belongs_to_many :methodologies, join_table: :methodology_placeholders
  has_many :placeholder_values
end
