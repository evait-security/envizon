# @restful_api 1.0
# Display/view stuff that's less model-specific
class PagesController < ApplicationController
  # @url /pages/refresh
  # @action GET
  #
  # Refreshes group view
  def refresh
    respond_to do |format|
      format.html {}
      format.js { render 'pages/group_refresh', locals: { message: 'Group content has been refreshed', type: 'success' } }
    end
  end
end
