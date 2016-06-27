class OauthController < ApplicationController

  require 'rest-client'
  require 'json'

  @@client_id = 'YTEzMmY5OTEtNDEyMC00MGM1LWFmOGUtMTBiNzVhNjRmMjQ0'
  @@client_secret = '8ae853bff25f54dd4bf54a8168a749d160d610c5724a50f4575a58cd0dfba9b9a6b9f7f08a60ba9c90fcedbb54ec95a697e2dc945220b77acabbc9dccfbbf339'
  @@api_token = '7411169a651e1910e7f007c2530de6ec0594a26cd27619c3e80e8836b6456505f1e891a0f5bd3a0db1988beee701be2f5ad79e4d81f57eb2d69301584374e88d'
  @@oauth_root_url = 'http://140.115.3.188/oauth'

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

    redirect_to root_path
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
