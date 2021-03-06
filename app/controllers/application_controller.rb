class ApplicationController < ActionController::Base


  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_filter :set_local


  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

#to redirect to same peag after Sign in 
protect_from_forgery

 def after_sign_in_path_for(resource)
   sign_in_url = new_user_session_url
   if request.referer == sign_in_url
     super
   else
     stored_location_for(resource) || request.referer || root_path
   end
 end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  private

  def set_local
    I18n.locale = 'ar'

    if (request.path.split('/')[1] == 'admin')
      I18n.locale = 'en'
    end
  end

end
