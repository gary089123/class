class SrentsController < ApplicationController
  before_action :has_access_token
  before_action :authenticate_user!
  before_action :set_srent , only: [:show,:update,:destroy,:edit]
  require 'rest-client'
  require 'json'


  def index

  end


  def create

    @srent = Srent.new(params_srent)
    @srent.user_id = current_user.id
    @srent.status = "待審核"
    @srent.save

    semester_s=Semester.find(@srent.semester_id).start
    semester_d=Semester.find(@srent.semester_id).end
    url =  ENV['api_facility'] +@srent.facility.to_s+'/rent'
    classes_arr=Array.new
    wday={1=>"一",2=>"二",3=>"三",4=>"四",5=>"五"}
    data=[]
    for j in 1..5
      for i in 1..9
        if params[j.to_s+"-"+i.to_s]=="1"

          classes_arr.push("星期"+wday[j]+"-"+(i+8-1).to_s+":00~"+(i+8).to_s+":00")
          day_ofs=j-semester_s.wday
          if day_ofs<0
            day_ofs=day_ofs+7
          end
          date=semester_s+day_ofs*24*60*60
          while date<=semester_d
            start=DateTime.new(date.year,date.mon,date.day,i+8-1)
            endt=DateTime.new(date.year,date.mon,date.day,i+8)
            @srent_time=SrentTime.new
            @srent_time.srent_id = @srent.id
            @srent_time.start=start
            @srent_time.end=endt
            puts start.to_s+"++++++"
            puts endt.to_s+"------"
            @srent_time.save
            h ={ :start =>start , :end => endt}
            data << h
            date=date+7*60*60*24
            puts date.to_s+"********"
          end
        end
      end
    end
    classes=classes_arr.join(",")
    @srent.classes=classes
    jdata=data.to_json
    url = ENV['api_facility'] + @srent.facility.to_s + '/rent'
    api = RestClient.post(url,
    {
      :name => @srent.name,
      :spans => jdata,
      :access_token => ENV['access_token']
    })
    japi=JSON.parse(api)
    puts japi["id"]
    @srent.apid = japi["id"].to_i
    @srent.save
    params[:format]=nil

    redirect_to srent_print_path
  end



  def destroy
    @srent_times=SrentTime.where( srent_id: @srent.id)
    @srent_times.each do |srent_time|
      srent_time.destroy
    end


    url = ENV['api_rent'] + @srent.apid.to_s + '?access_token='+ENV['access_token']
    api = RestClient.delete(url , {})

    @srent.destroy
    redirect_to :back
  end




  def update

  end


  def print
    if params[:format]==nil
      @srent=Srent.last
    else
      @srent=Srent.find(params[:format])
    end
    @user=User.find(@srent.user_id)
  end

  private
    def params_srent
      params.require(:srent).permit(:facility,:name,:semester_id ,:email,:phone,:teacher)
    end

    def set_srent
      @srent=Srent.find(params[:id])
    end
end
