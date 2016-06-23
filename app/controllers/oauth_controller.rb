class OauthController < ApplicationController

  require 'rest-client'
  require 'json'

  @@client_id = 'ZDc0ODhjOTQtYzhjYi00ZTA0LWJlOWQtMzNmNTQyMjIwZmE1'
  @@client_secret = '206f1e4607ac584eb776107b62d03ad26d4f04405a042cea551ccca32b7b8a8695bf3b59aea1047c53e9eb6a82dcc67f53f04f5b58a60b3be20321ec132160f7'
  @@oauth_root_url = 'https://api.cc.ncu.edu.tw/oauth'

  def oauth
    scope = 'course.schedule.read+calendar.event.read+calendar.event.write+user.info.basic.read'
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

    redirect_to root_path
  end

# just for test
  def getperson
    url = 'https://api.cc.ncu.edu.tw/personnel/v1/info'
    @api = RestClient.get url, { 'Authorization' => 'Bearer ' + ENV['access_token'] }
    respond_to do |format|
      format.any { render :text => @api }
    end
  end

end
