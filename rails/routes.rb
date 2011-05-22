if defined?(Rails::Application)
  Rails.application.routes.draw do
    # TODO: Allow override with config
    
    post '/persona', :to => 'persona#login', :as => :persona_login
    get '/persona/logout', :to => 'persona#logout', :as => :persona_logout
  end
end
