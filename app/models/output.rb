class Output < ApplicationRecord
  belongs_to :client, optional: true
  belongs_to :port, optional: true
end
