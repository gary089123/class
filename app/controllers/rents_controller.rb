class RentsController < ApplicationController
  before_action :has_access_token
  before_action :authenticate_user! , except: [:index]
  before_action :set_rent , only: [:show , :edit ,:update,:destroy]
  require 'rest-client'
  require 'json'

  def index
    # 臨時性的時間列出 /rents
    @rent_202 = Rent.joins(:semester).where('semesters.is_open', true).where(facility: 4)
    @rent_210 = Rent.joins(:semester).where('semesters.is_open', true).where(facility: 5)
    @rent_002 = Rent.joins(:semester).where('semesters.is_open', true).where(facility: 6)
    @rent_202 = @rent_202.order("semester_id asc")
    @rent_210 = @rent_210.order("semester_id asc")
    @rent_002 = @rent_002.order("semester_id asc")
  end

  def search
    @rent=Rent.where(user_id: current_user.id)
    @srent=Srent.where(user_id: current_user.id)
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
    ## API - 刪除rent
    # url = ENV['api_rent'] + @rent.apid.to_s + '?access_token='+ENV['access_token']
    # api = RestClient.delete(url , {})

    # 刪除臨時性借用的時間
    @rent.rent_times.destroy_all
    # 刪除臨時性借用
    @rent.destroy
    redirect_to :back
  end


  def new
    @rent_202 = ENV['rent_202']
    @rent_210 = ENV['rent_210']
    @rent_002 = ENV['rent_002']
    @rent=Rent.new
    @srent=Srent.new
    @semesters = Semester.where(is_open: true)
  end

  def create

    rent = params[:rent]
    @rent = Rent.new(params_rent)
    @rent.user_id = current_user.id
    @rent.status = "待審核"
    @rent.save

    # for api time spans
    data = [];
    # 計算有幾個時間區間, default is 1
    num = rent[:calculus].to_i

    # loop every time spans
    i = 0
    while i < num do
      if (rent["year"+i.to_s]!=nil && rent["month"+i.to_s]!=nil && rent["day"+i.to_s]!=nil && rent["start_time"+i.to_s]!=nil \
        && rent["year"+i.to_s]!=nil && rent["month"+i.to_s]!=nil && rent["day"+i.to_s]!=nil && rent["end_time"+i.to_s]!=nil)

        # 時間格式轉換
        start = Time.new(rent["year"+i.to_s].to_i ,rent["month"+i.to_s].to_i ,rent["day"+i.to_s].to_i ,rent["start_time"+i.to_s].to_i, 0)
        endt = Time.new(rent["year"+i.to_s].to_i ,rent["month"+i.to_s].to_i ,rent["day"+i.to_s].to_i ,rent["end_time"+i.to_s].to_i, 0)

        # 結束時間當然要大於開始時間
        if !(start < endt)
          @rent.rent_times.destroy_all
          @rent.destroy
          return redirect_to :back, notice: '結束時間必須大於開始時間'
        end

        # 時間應該介於 這學期的start ~ end
        if !( @rent.semester.start <= start && endt <= @rent.semester.end )
          @rent.rent_times.destroy_all
          @rent.destroy
          return redirect_to :back, notice: '時間未在您輸入的學期內'
        end

        # 檢查是否跟臨時性重疊
        @all_rents = Rent.where(semester_id: rent[:semester_id], facility: rent[:facility])
        @all_rents.each do |all_rent|
          all_rent.rent_times.each do |rent_time|
            if check_conflict?( [start, endt], [rent_time.start,rent_time.end] )
              @rent.rent_times.destroy_all
              @rent.destroy
              return redirect_to :back, notice: '該時段已被申請'
            end
          end
        end

        # TODO: 檢查是否跟學期性撞時

        # rent_time 資料表
        @rent_time = RentTime.new
        @rent_time.rent_id = @rent.id
        @rent_time.start = start
        @rent_time.end = endt
        @rent_time.save

        # for api
        h = { :start => start ,:end => endt }
        data << h
      end

      i += 1
    end

    ## API - 新增rent
    # jdata=data.to_json
    # url = ENV['api_facility'] + @rent.facility.to_s + '/rent'
    # api = RestClient.post(url,
    # {
    #   :name => @rent.name,
    #   :spans => jdata,
    #   :access_token => ENV['access_token']
    # })
    # japi=JSON.parse(api)

    # 取得api的rent id以備更新或刪除
    # @rent.apid = japi["id"].to_i
    # @rent.save

    # 意義不明?
    # params[:format]=nil

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

  def set_rent
    @rent=Rent.find(params[:id])
  end

  def params_rent
    params.require(:rent).permit(:semester_id,:name,:teacher,:phone,:email,:facility)
  end

end
