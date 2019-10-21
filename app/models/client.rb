# frozen_string_literal: true

class Client < ApplicationRecord
  has_many :ports, dependent: :destroy
  has_many :outputs, dependent: :destroy
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :labels
  has_many :client_report_parts
  has_many :report_parts, through: :client_report_parts, foreign_key: :report_part_id, class_name: 'ReportPart', source: 'report_part'

  def images
    ports.joins(:image_attachment).map(&:image).sort(&:created_at)
  end
end
