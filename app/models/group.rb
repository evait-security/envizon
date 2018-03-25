class Group < ApplicationRecord
  validates :name, presence: true
  has_and_belongs_to_many :clients, -> { distinct }
end
