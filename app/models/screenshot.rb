class Screenshot < ApplicationRecord
  belongs_to :report_part
  has_one_attached :image

  def size_relation
    relation = 0
    begin
      dimension = ActiveStorage::Analyzer::ImageAnalyzer.new(self.image).metadata
      relation = dimension[:height].to_f / dimension[:width].to_f
    rescue => exception
    end
    relation = 1 if relation <= 0
    relation
  end
end
