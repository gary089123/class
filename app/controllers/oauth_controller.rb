class OauthController < ApplicationController

  require 'rest-client'
  require 'json'

  @@client_id = ENV['client_id']
  @@client_secret = ENV['client_secret']
  @@api_token = ENV['api_token']
  @@oauth_root_url = ENV['oauth_root_url']

  def oauth
    scope = 'facility.rent.read+facility.rent.write+facility.rent.verify+facility.manage+user.info.basic.read'
    url = @@oauth_root_url + '/oauth/authorize?response_type=code&scope=' + scope + '&client_id=' + @@client_id
    redirect_to url
  end

  def callback
    code = params[:code] # get params :code from url
    url = @@oauth_root_url + '/oauth/token'
    @access = RestClient.post( url,
    {
       :grant_type => 'authorization_code',
       :code => code,
       :client_id => @@client_id,
       :client_secret => @@client_secret
    })

    # parse to json and get it
    jdoc = JSON.parse(@access)
    access_token= jdoc.fetch("access_token")
    ENV['access_token'] = access_token


    url = ENV['api_personnel']
    api = RestClient.get url, { 'Authorization' => 'Bearer ' + ENV['access_token']}

    userinfo=api.split(/[,":{}]/).reject(&:empty?)
    user = User.find_by(idnumber:userinfo[1])
    if user==nil
      user=User.create(idnumber:userinfo[1].force_encoding('UTF-8'),name:userinfo[5].force_encoding('UTF-8'),unit:userinfo[9].force_encoding('UTF-8'),privilege:1)
    end
    session[:user_id]=user.id
    puts user_signed_in?
    redirect_to root_path
  end

  def logout
    session.delete(:user_id)
    ENV['access_token'] = nil
    redirect_to root_path , notice: '登出成功 Logout Success'
  end

# just for test
  def getfacility
    id = '1'
    url = 'http://140.115.3.188/facility/v1/facility/' + id
    api = RestClient.get url, { 'X-NCU-API-TOKEN' => @@api_token, 'Authorization' => ENV['access_token']}
    respond_to do |format|
      format.any { render :text => api }
    end
  end

  def getperson
    url = 'http://140.115.3.188/personnel/v1/info'
    api = RestClient.get url, { 'Authorization' => 'Bearer ' + ENV['access_token']}
    respond_to do |format|
      format.any { render :text => api }
    end
  end


end
