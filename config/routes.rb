Rails.application.routes.draw do

# 首頁
  root 'staticpages#index'

# 使用說明 與 借用狀態
  scope :controller => "staticpages", :path => "/pages", :as => "pages" do
    get 'readme'
    get 'status'
  end

# Oauth
  get 'oauth', :to => 'oauth#oauth'
  get 'callback', :to => 'oauth#callback'
  get 'logout', :to => 'oauth#logout'

# api testing
  get 'getfacility', :to => 'oauth#getfacility'
  get 'getperson', :to => 'oauth#getperson'

# 預約
  resources :rents
  get 'search', :controller => 'rents'
  get 'rent/print' ,:to => 'rents#print'

  # 長期預約
    resources :srents
    get 'srent/print' ,:to => 'srents#print' 

# Admin
  scope :controller => 'admin', :path => 'admin', :as => 'admin' do
    get '/', :to => 'admin#index'
    get 'vertify' ,:to => 'admin#vertify'
    get 'unvertify', :to=> 'admin#unvertify'
    get 'svertify' ,:to => 'admin#svertify'
    get 'sunvertify', :to=> 'admin#sunvertify'
    get 'listsemester', :to=> 'admin#listsemester'
    post 'semesters', :to => 'admin#create_semester'
    delete 'semesters/:id', :to => 'admin#destory_semester', :as => 'semester'
    patch 'semesters/:id', :to => 'admin#update_semester'
  end

end
