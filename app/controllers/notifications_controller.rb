class NotificationsController < ApplicationController
  def new
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render :new, locals: { message: params[:message] } }
    end
  end
end
