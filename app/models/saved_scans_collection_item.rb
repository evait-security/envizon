class SavedScansCollectionItem < ApplicationRecord
  belongs_to :SavedScansCollection
  belongs_to :SavedScan
end
