if defined?(Rails::Application)
  Rails.application.routes.draw do
    # TODO: Allow override with config
    
    post '/sybil', :to => 'sybil#login', :as => :sybil_login
    get '/sybil/logout', :to => 'sybil#logout', :as => :sybil_logout
  end
end
