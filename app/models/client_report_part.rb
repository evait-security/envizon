class ClientReportPart < ApplicationRecord
  belongs_to :report_part
  belongs_to :client
end
