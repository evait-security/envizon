class PlaceholderSet < ApplicationRecord
  has_and_belongs_to_many :placeholder_values, join_table: :placeholder_v_placeholder_s
end
