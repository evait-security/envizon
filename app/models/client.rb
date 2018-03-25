class Client < ApplicationRecord
  has_many :ports, dependent: :destroy
  has_many :outputs, dependent: :destroy
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :labels
end
