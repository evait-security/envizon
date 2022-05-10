class Methodology < ApplicationRecord
  has_and_belongs_to_many :placeholders, join_table: :methodology_placeholders
  belongs_to :methodology_category
  belongs_to :methodology_book


  def content_with_placeholders(placeholder_set_id)
    result = content
    PlaceholderSet.find_by(id: placeholder_set_id)&.placeholder_values
                                                  &.sort_by{|placeholder_value| placeholder_value.placeholder.name.length}.reverse
                                                  &.each do |placeholder_value|
      result&.gsub!("@@#{placeholder_value.placeholder.name}", "#{placeholder_value.content}")
    end
    result
  end
end
