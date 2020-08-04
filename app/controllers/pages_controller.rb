# @restful_api 1.0
# Display/view stuff that's less model-specific
class PagesController < ApplicationController
    def settings
        @mysql_connection = YAML.safe_load(current_user.settings.where(name: 'mysql_connection').first_or_create.value.to_yaml)
        @mysql_connection ||= '0'
    end
end
