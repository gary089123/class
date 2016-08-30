class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user , :user_signed_in?

  ENV['vertify_202'] = 'akpgt98gj0d9a53r7d7lj94kvc@group.calendar.google.com'
  ENV['vertify_210'] = 'jnp6sauodn4e4v5hagn8sog4i4@group.calendar.google.com'
  ENV['vertify_002'] = 'sbbin0bcvk7c5r5ckle6nt4b88@group.calendar.google.com'
  ENV['rent_202'] = 'rr7j9s4d5k21c4bcicn50ccpv8@group.calendar.google.com'
  ENV['rent_210'] = 'iv6su9k0daaod3i3vgia1lfktc@group.calendar.google.com'
  ENV['rent_002'] = 'g2cjaf2h5p45gl29lpbseuan2o@group.calendar.google.com'

  def current_user
    if session[:user_id]==nil
      @current_user =nil
    else
     @current_user ||= User.find_by(session[:user_id])
    end
  end

  def user_signed_in?
    current_user != nil
  end

  def authenticate_user!
    unless user_signed_in?
      redirect_to oauth_path, notice: 'Please Login'
    end
  end
end
