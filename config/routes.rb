Rails.application.routes.draw do

  devise_for :admins
  root 'staticpages#index'

# 使用說明 與 借用狀態
  scope :controller => "staticpages", :path => "/pages", :as => "pages" do
    get 'readme'
    get 'status'
  end

# get access_token
  get 'oauth', :to => 'oauth#oauth'
  get 'callback', :to => 'oauth#callback'

  get 'logout', :to => 'oauth#logout'

# api testing
  get 'getfacility', :to => 'oauth#getfacility'
  get 'getperson', :to => 'oauth#getperson'

# 預約
  resources :rents
  get 'search', :controller => 'rents'

#預約 CRUD

end
