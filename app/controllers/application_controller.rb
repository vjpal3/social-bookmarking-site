class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.

  protect_from_forgery unless: -> { request.format.json? }

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :store_user_location!, if: :storable_location?
  # The callback which stores the current location must be added before you authenticate the user
  # as `authenticate_user!` (or whatever your resource is) will halt the filter chain and redirect
  # before the location can be stored.
  # before_action :authenticate_user!

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  private
  def storable_location?
      request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
    end

    def store_user_location!
      store_location_for(:user, request.fullpath)
    end

   def after_sign_in_path_for(resource_or_scope)
    if current_user.admin?
       root_path
     else
        stored_location_for(resource_or_scope) || super
       # articles_path
    end
  end


   # def after_sign_in_path_for(resource)
   #  if current_user.admin?
   #    root_path
   #  else
   #    articles_path
   # end



   # def after_sign_out_path_for(resource_or_scope)
   #   request.referrer || super
   # end

end
