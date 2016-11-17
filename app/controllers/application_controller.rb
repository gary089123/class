class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user , :user_signed_in?

  # I202 id: 4
  ENV['vertify_202'] = 'akpgt98gj0d9a53r7d7lj94kvc@group.calendar.google.com'
  ENV['rent_202'] = 'rr7j9s4d5k21c4bcicn50ccpv8@group.calendar.google.com'
  # I210 id: 5
  ENV['vertify_210'] = 'jnp6sauodn4e4v5hagn8sog4i4@group.calendar.google.com'
  ENV['rent_210'] = 'iv6su9k0daaod3i3vgia1lfktc@group.calendar.google.com'
  # I002 id: 6
  ENV['vertify_002'] = 'sbbin0bcvk7c5r5ckle6nt4b88@group.calendar.google.com'
  ENV['rent_002'] = 'g2cjaf2h5p45gl29lpbseuan2o@group.calendar.google.com'
  # API
  ENV['client_id'] = 'YTEzMmY5OTEtNDEyMC00MGM1LWFmOGUtMTBiNzVhNjRmMjQ0'
  ENV['client_secret'] = '8ae853bff25f54dd4bf54a8168a749d160d610c5724a50f4575a58cd0dfba9b9a6b9f7f08a60ba9c90fcedbb54ec95a697e2dc945220b77acabbc9dccfbbf339'
  ENV['api_token'] = '7411169a651e1910e7f007c2530de6ec0594a26cd27619c3e80e8836b6456505f1e891a0f5bd3a0db1988beee701be2f5ad79e4d81f57eb2d69301584374e88d'
  ENV['oauth_root_url'] = 'http://140.115.3.188/oauth'
  ENV['api_personnel'] = 'http://140.115.3.188/personnel/v1/info'
  ENV['api_facility'] = 'http://140.115.3.188/facility/v1/facility/'
  ENV['api_rent'] = 'http://140.115.3.188/facility/v1/rent/'
  # 借用時段的時間 8點到22點
  ENV['rent_start_time']='8'
  ENV['rent_finish_time']='22'



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
      redirect_to oauth_path, notice: '登入成功 Login Success'
    end
  end

  # 檢查是否有api的access_token
  def has_access_token
    if ENV['access_token'] == nil
      redirect_to oauth_path, notice: '登入成功 Login Success'
    end
  end

  # 檢查輸入的兩個時間區間是否重複
  # ref: http://stackoverflow.com/questions/28667368/how-to-check-a-datetime-duration-exists-in-another-datetime-duration
  # check_conflict?(["2015-02-23 10:30:00", "2015-02-23 13:30:00"],
  #                 ["2015-02-23 12:30:00", "2015-02-23 14:30:00"])
  # => true
  # check_conflict?(["2015-02-23 10:30:00", "2015-02-23 12:30:00"],
  #                 ["2015-02-23 12:30:00", "2015-02-23 13:30:00"])
  # => false
  def check_conflict?(exam1, exam2)
    !(exam1.last <= exam2.first || exam1.first >= exam2.last)
  end

end
