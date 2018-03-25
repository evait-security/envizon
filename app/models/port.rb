class Port < ApplicationRecord
  validates :number, presence: true
  belongs_to :client
  has_many :outputs, dependent: :destroy
end
