class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # layout "bootstrap"

  protect_from_forgery with: :exception
  before_action :authenticate_user!

  # overwrite default path after sign in
  def after_sign_in_path_for(ressource)
    new_scan_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  protected

  def respond_with_notify(message = 'Please make a selection', type = 'warning', js = '')
    if message.is_a?(Hash) # if called from settings controller (only one argument can passed in this situation)
      @message = message[:message]
      @type = message[:type]
    else
      @message = message
      @type = type
    end
    respond_to do |format|
      format.html { redirect_to request.referrer } # nice workaround for not working redirect_to :back but without notification
      format.js { render 'layouts/notification' }
    end
  end
end
