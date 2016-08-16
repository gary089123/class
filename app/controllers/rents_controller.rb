class RentsController < ApplicationController

  require 'rest-client'
  require 'json'

  @@api_token = '7411169a651e1910e7f007c2530de6ec0594a26cd27619c3e80e8836b6456505f1e891a0f5bd3a0db1988beee701be2f5ad79e4d81f57eb2d69301584374e88d'

  def index
    @rent_calendar_url = 'redli5vtl6ogmn9s9v7f37g1u4@group.calendar.google.com'   
  end

  def search
    
  end

  def new 
    @rent=Rent.new
  end

  def create
    #@rent = Rent.new(rent_params)
    puts params[:rent][:start]
    #if params[:rent][:start]==nil
    #  puts 'whats the fucks'
    end 
    #url = 'http://140.115.3.188/facility/v1/facility/1/rent'
    #api = ResClient.get url, {'Authorization' => ENV['access_token'] , 'id' => params[:rent][:facility] , 'name' => params[:rent][:idnumber] , 'spans[start]' => params[:rent][:start] , 'span[end]' => params[:rent][:end]}
    redirect_to root_path 
  end

end
