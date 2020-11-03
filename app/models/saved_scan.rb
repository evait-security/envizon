class SavedScan < ApplicationRecord
    has_many :notes, as: :noteable
end
