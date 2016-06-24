Rails.application.routes.draw do

  root 'staticpages#index'

# 使用說明 與 借用狀態
  scope :controller => "staticpages", :path => "/pages", :as => "pages" do
    get 'readme'
    get 'status'
  end

# get access_token
  get 'oauth', :to => 'oauth#oauth'
  get 'callback', :to => 'oauth#callback'

# api testing
  get 'getfacility', :to => 'oauth#getfacility'

# 預約
  resources :rents
  get 'search', :controller => 'rents'

#預約 CRUD

end
