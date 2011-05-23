if defined?(Rails::Application)
  Rails.application.routes.draw do    
    post '/sybil', :to => 'sybil#login', :as => :sybil_login
    get '/sybil/logout', :to => 'sybil#logout', :as => :sybil_logout
  end
end
