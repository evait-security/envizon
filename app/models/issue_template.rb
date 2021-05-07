class IssueTemplate < ApplicationRecord
  has_many :issues

  def color_hex
    case severity
    when 0
      '#3fb079;'
    when 1
      '#0b5394;'
    when 2
      '#b45f06;'
    when 3
      '#990000;'
    when 4
      '#9900ff;'
    else
      '#999999;'
    end
  end
end
