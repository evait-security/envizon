class Group < ApplicationRecord
  validates :name, presence: true
  has_and_belongs_to_many :clients, -> { distinct }
  
  def images
    clients.map{|c| c.images}.flatten.sort{|i| i.created_at}.reverse
  end
end
