class IssueTemplate < ApplicationRecord
    def color
        case severity
        when 0
          return "green"
        when 1
            return "blue"
        when 2
            return "orange"
        when 3
            return "red"
        when 4
            return "purple"
        else
            return "grey"
        end  
    end
end
