class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :set_admin

  require 'rest-client'

  def index
    if params[:search]
      @user = User.where('name Like ? OR idnumber Like ?',"%#{params[:search]}%","%#{params[:search]}%" )
      @rent = Rent.where(:user_id => @user.ids)
      puts @user.ids
    else
      @rent = Rent.all
    end
  end

  def vertify
    @rent=Rent.find(params[:format])
    url = ENV['api_rent'] + @rent.apid.to_s+'/verify'
    puts url
    api = RestClient.put( url, { 'access_token'=> ENV['access_token'], 'id'=>@rent.apid.to_s, 'verify'=>true})
    @rent.status="已借出"
    @rent.save
    redirect_to admin_path
  end

  def unvertify
    @rent=Rent.find(params[:format])
    url = ENV['api_rent'] + @rent.apid.to_s+'/verify'
    puts url
    api = RestClient.put( url, { 'access_token'=> ENV['access_token'], 'id'=>@rent.apid.to_s, 'verify'=>false})
    @rent.status="待審核"
    @rent.save
    redirect_to admin_path
  end

  def listsemester
    @semesters = Semester.all
    @semester = Semester.new
  end

  def create_semester
    # abort params[:semester].inspect
    semester = params[:semester]
    @semester = Semester.new
    @semester.name = semester[:name]
    @semester.updown = semester[:updown]
    if semester[:updown] == '0'
      updown = '上學期'
    elsif semester[:updown] == '1'
      updown = '下學期'
    else
      abort 'error'
    end
    @semester.description = semester[:name].to_s + updown
    @semester.is_open = semester[:is_open]
    @semester.start = Time.new(semester["start(1i)"],semester["start(2i)"],semester["start(3i)"],0,0,0)
    @semester.end = Time.new(semester["end(1i)"],semester["end(2i)"],semester["end(3i)"],0,0,0)
    @semester.save
    redirect_to :back
  end

  def update_semester
    @semester = Semester.find(params[:id])
    semester = params[:semester]
    @semester.name = semester[:name]
    @semester.updown = semester[:updown]
    if semester[:updown] == '0'
      updown = '上學期'
    elsif semester[:updown] == '1'
      updown = '下學期'
    else
      abort 'error'
    end
    @semester.description = semester[:name].to_s + updown
    @semester.is_open = semester[:is_open]
    @semester.start = Time.new(semester["start(1i)"],semester["start(2i)"],semester["start(3i)"],0,0,0)
    @semester.end = Time.new(semester["end(1i)"],semester["end(2i)"],semester["end(3i)"],0,0,0)
    @semester.save
    redirect_to :back
  end

  def destory_semester
    @semester = Semester.find(params[:id])
    @semester.destroy
    redirect_to :back
  end

  private

  def set_admin
    if current_user.privilege==1
      redirect_to root_path , notice: 'no privilege'
    end
  end

end
