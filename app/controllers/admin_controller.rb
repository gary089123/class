class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :set_admin
  
  require 'rest-client'


  @@api_token = '7411169a651e1910e7f007c2530de6ec0594a26cd27619c3e80e8836b6456505f1e891a0f5bd3a0db1988beee701be2f5ad79e4d81f57eb2d69301584374e88d'

  def index
    @rent = Rent.All
  end

  def verify
    url = 'http://140.115.3.188/facility/v1/rent/15/verify'
    api = RestClient.put( url, { 'access_token'=> ENV['access_token'], 'id'=>'15', 'verify'=>true})
 redirect_to root_path 
 end




  private

  def set_admin 
    if current_user.privilege==1
      redirect_to root_path , notice: 'no privilege'
    end
  end



end
