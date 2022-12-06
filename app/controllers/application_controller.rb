class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :authenticate_user!

    before_action :update_allowed_parameters, if: :devise_controller?
    before_action :set_cart

  protected

  def update_allowed_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :surname, :email, :password, :admin, :activated)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :surname, :email, :password, :current_password, :admin, :activated)}
  end

  private 

  def set_cart
    if session[:cart_id]
      cart = Cart.find_by(id: session[:cart_id])
      cart.present? ? (@current_cart = cart) : (session[:cart_id] = nil)
    end
    return unless session[:cart_id].nil?

    @current_cart = Cart.create(user_id: nil)
    session[:cart_id] = @current_cart.id
  end

  def current_user?(user)
    user == current_user
  end
  def logged_in?
    !current_user.nil?
  end

  # # Returns the current logged-in user (if any).
  # def current_user
  #   if (user_id = session[:user_id])
  #     @current_user ||= User.find_by(id: user_id)
  #   elsif (user_id = cookies.signed[:user_id])
  #     user = User.find_by(id: user_id)
  #     if user && user.authenticated?(:remember, cookies[:remember_token])
  #       log_in user
  #       @current_user = user
  #     end
  #   end
  # end

  def logged_in_user
    return if user_signed_in?

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to new_user_session_path
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  # def store_location
  #   session[:forwarding_url] = request.original_url if request.get?
  # end

  def user_is_admin 
    binding.pry
    return if user_signed_in? && current_user.admin?

    flash[:info] = "You don't have the privilages for this action!"
    redirect_back(fallback_location: root_url)
  end
  def user_is_admin
    return if logged_in? && current_user.admin?

    flash[:info] = "You don't have the privilages for this action!"
    redirect_back(fallback_location: root_url)
  end
  
end
