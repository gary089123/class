class RentsController < ApplicationController

  before_action :authenticate_user! , except: [:index]
  before_action :set_rent , only: [:show , :edit ,:update,:destroy]
  require 'rest-client'
  require 'json'

  @@api_token = '7411169a651e1910e7f007c2530de6ec0594a26cd27619c3e80e8836b6456505f1e891a0f5bd3a0db1988beee701be2f5ad79e4d81f57eb2d69301584374e88d'

  def index
    @rent_202 = ENV['rent_202']
    @rent_210 = ENV['rent_210']
    @rent_002 = ENV['rent_002']
  end

  def search
    @rent=Rent.where(user_id: current_user.id)

  end

  def show

  end

  def edit

  end

  def update
    @rent.update(params_rent)
    puts @rent.apid
    url = 'http://140.115.3.188/facility/v1/facility/rent'+@rent.apid.to_s
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
    api = RestClient.put(url,
    {
      :id => @rent.apid.to_s,
      :name => @rent.name,
      :spans => jdata,
      :access_token => ENV['access_token']
    })
    redirect_to :back

  end

  def destroy
    puts @rent.facility
    url = 'http://140.115.3.188/facility/v1/rent/'+@rent.apid.to_s+'?access_token='+ENV['access_token']
    api = RestClient.delete(url , {})
    @rent.destroy
    redirect_to admin_path
  end


  def new
    @rent_202 = ENV['rent_202']
    @rent_210 = ENV['rent_210']
    @rent_002 = ENV['rent_002']
    @rent=Rent.new
  end

  def create
    @rent = Rent.new(params_rent)
    @rent.user_id = current_user.id
    @rent.status = "待審核"
    url = 'http://140.115.3.188/facility/v1/facility/'+@rent.facility.to_s+'/rent'
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
      :name => @rent.name,
      :spans => jdata,
      :access_token => ENV['access_token']
    })
    japi=JSON.parse(api)
    puts japi["id"]
    @rent.apid = japi["id"].to_i
    @rent.save
    params[:format]=nil
    redirect_to rent_print_path
  end


  def print
    if params[:format]==nil
      @rent=Rent.last
    else
      @rent=Rent.find(params[:format])
    end
    puts @rent.user_id
    @user=User.find(@rent.user_id)
    puts @user.name
  end


  private
  def set_rent
    @rent=Rent.find(params[:id])
  end

  def params_rent
    params.require(:rent).permit(:facility,:name,:start,:end)

  end

end
