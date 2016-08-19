class RentsController < ApplicationController
  
  require 'rest-client'
  require 'json'

  @@api_token = '7411169a651e1910e7f007c2530de6ec0594a26cd27619c3e80e8836b6456505f1e891a0f5bd3a0db1988beee701be2f5ad79e4d81f57eb2d69301584374e88d'

  def index
    @rent_calendar_url = 'redli5vtl6ogmn9s9v7f37g1u4@group.calendar.google.com'   
  end

  def search
    @rent=Rent.find_by(idnumber: session[:idnumber]) 
  end

  def new 
    @rent=Rent.new
  end

  def create
    puts @rent = Rent.new(params_rent)
    #puts params[:rent][:start]
    #if params[:rent][:start]==nil
    #  puts 'whats the fucks'
    # end 
    puts url = 'http://140.115.3.188/facility/v1/facility/'+@rent.facility.to_s+'/rent'
    rent = params[:rent]
    start = DateTime.new(rent["start(1i)"].to_i ,rent["start(2i)"].to_i ,rent["start(3i)"].to_i ,rent["start(4i)"].to_i, rent["start(5i)"].to_i)
    endt = DateTime.new(rent["end(1i)"].to_i ,rent["end(2i)"].to_i ,rent["end(3i)"].to_i ,rent["end(4i)"].to_i, rent["end(5i)"].to_i)

    data = [
      {
    	:start => start,
        :end => endt 
      }
    ]
    jdata=data.to_json
    api = RestClient.post(url,
    {
      :name => @rent.idnumber,
      :spans => jdata,
      :access_token => ENV['access_token']
    })
    
    redirect_to root_path 
  end
  


  private

  def params_rent
    params.require(:rent).permit(:facility,:idnumber,:start,:end)

  end

end
