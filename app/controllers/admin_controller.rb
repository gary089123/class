class AdminController < ApplicationController
  before_action :set_admin
  
  def index
    @rent = Rent.All
  end

  def check

  end





  def set_admin 
    if current_user.privilege==1
      redirect_to root_path , notice :'no privilege'
    end
  end



end
