if defined?(Rails::Application)
  Rails.application.routes.draw do
    post '/persona', :to => 'persona#login', :as => :persona_login
    get '/persona/logout', :to => 'persona#logout', :as => :persona_logout
  end
end
