class Label < ApplicationRecord
  has_and_belongs_to_many :clients
  has_many :notes, as: :noteable
end
