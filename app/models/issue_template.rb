class IssueTemplate < ApplicationRecord
    def color
        case severity
        when 0..999
          return "green"
        when 1000..1999
            return "blue"
        when 2000..2999
            return "orange"
        when 3000..3999
            return "red"
        when 4000..4999
            return "purple"
        else
            return "grey"
        end  
    end
end
