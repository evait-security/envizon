class PlaceholderValue < ApplicationRecord
  has_and_belongs_to_many :placeholder_sets, join_table: :placeholder_v_placeholder_s
  belongs_to :placeholder
end
