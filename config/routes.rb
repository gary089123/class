Rails.application.routes.draw do

root 'staticpages#index'

# get access_token
  get 'oauth', :to => 'oauth#oauth'
  get 'callback', :to => 'oauth#callback'

# api
  get 'getfacility', :to => 'oauth#getfacility'
end
