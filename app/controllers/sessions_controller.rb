class SessionsController < Devise::SessionsController

    before_action :check_user_count?, only: [:new, :create]
    
    protected
  
    def check_user_count?
      if User.count == 0
        redirect_to new_user_registration_path
      end 
    end
end