class RentsController < ApplicationController
  before_action :has_access_token
  before_action :authenticate_user! , except: [:index]
  before_action :set_rent , only: [:show , :edit ,:update,:destroy]
  require 'rest-client'
  require 'json'

  def index
    @rent_202 = ENV['rent_202']
    @rent_210 = ENV['rent_210']
    @rent_002 = ENV['rent_002']
  end

  def search
    @rent=Rent.where(user_id: current_user.id)
    # abort @rent_times.inspect
    # abort @rent.inspect
  end

  def show

  end

  def edit

  end

  def update
    # @rent.update(params_rent)
    # puts @rent.apid
    # url = 'http://140.115.3.188/facility/v1/rent/'+@rent.apid.to_s
    # rent = params[:rent]
    # start = DateTime.new(rent["start(1i)"].to_i ,rent["start(2i)"].to_i ,rent["start(3i)"].to_i ,rent["start(4i)"].to_i, rent["start(5i)"].to_i)
    # endt = DateTime.new(rent["end(1i)"].to_i ,rent["end(2i)"].to_i ,rent["end(3i)"].to_i ,rent["end(4i)"].to_i, rent["end(5i)"].to_i)
    #
    # data = [
    #   {
    #     :start => start,
    #     :end => endt
    #   }
    # ]
    # jdata=data.to_json
    # api = RestClient.put(url,
    # {
    #   :id => @rent.apid.to_s,
    #   :name => @rent.name,
    #   :spans => jdata,
    #   :access_token => ENV['access_token']
    # })
    redirect_to rent_print_path

  end

  def destroy
    puts @rent.facility
    url = ENV['api_rent'] + @rent.apid.to_s + '?access_token='+ENV['access_token']
    api = RestClient.delete(url , {})
    @rent.destroy
    redirect_to :back
  end


  def new
    @rent_202 = ENV['rent_202']
    @rent_210 = ENV['rent_210']
    @rent_002 = ENV['rent_002']
    @rent=Rent.new
    @semesters = Semester.where(is_open: true)
    # abort @semesters.inspect
  end

  def create
    # abort params[:rent].inspect
    # @rent = Rent.new(params_rent)
    @rent = Rent.new
    @rent.semester_id = params[:rent][:semester_id]
    @rent.name = params[:rent][:name]
    @rent.facility = params[:rent][:facility]
    @rent.user_id = current_user.id
    @rent.status = "待審核"
    # abort @rent.inspect
    @rent.save

    data = [];
    rent = params[:rent]
    num = rent[:calculus].to_i
    if num > 0
      i = 0
      while i < num do
        if (rent["year"+i.to_s]!=nil && rent["month"+i.to_s]!=nil && rent["day"+i.to_s]!=nil && rent["start_time"+i.to_s]!=nil \
          && rent["year"+i.to_s]!=nil && rent["month"+i.to_s]!=nil && rent["day"+i.to_s]!=nil && rent["end_time"+i.to_s]!=nil)

          start = Time.new(rent["year"+i.to_s].to_i ,rent["month"+i.to_s].to_i ,rent["day"+i.to_s].to_i ,rent["start_time"+i.to_s].to_i, 0)
          endt = Time.new(rent["year"+i.to_s].to_i ,rent["month"+i.to_s].to_i ,rent["day"+i.to_s].to_i ,rent["end_time"+i.to_s].to_i, 0)

          # rent_time 資料表
          @rent_time = RentTime.new
          @rent_time.rent_id = @rent.id
          @rent_time.start = start
          @rent_time.end = endt
          @rent_time.save

          # api
          h = { :start => start ,:end => endt }
          data << h
        end

        i += 1
      end
    end
    # abort data.inspect


    # rent = params[:rent]
    # start = DateTime.new(rent["start(1i)"].to_i ,rent["start(2i)"].to_i ,rent["start(3i)"].to_i ,rent["start(4i)"].to_i, rent["start(5i)"].to_i)
    # endt = DateTime.new(rent["start(1i)"].to_i ,rent["start(2i)"].to_i ,rent["start(3i)"].to_i ,rent["end(4i)"].to_i, rent["end(5i)"].to_i)
    # data = [
    #   {
    #     :start => start,
    #     :end => endt
    #   }
    # ]

    jdata=data.to_json
    url = ENV['api_facility'] + @rent.facility.to_s + '/rent'
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
    # puts @rent.user_id
    @user=User.find(@rent.user_id)
    # puts @user.name
  end


  private

  def has_access_token
    if ENV['access_token'] == nil
      redirect_to oauth_path, notice: 'Please Login'
    end
  end

  def set_rent
    @rent=Rent.find(params[:id])
  end

  def params_rent
    params.require(:rent)#.permit(:facility,:name,:start,:end)

  end

end
