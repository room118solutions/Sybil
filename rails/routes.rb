if defined?(Rails::Application)
  Rails.application.routes.draw do    
    post '/sybil', :to => 'sybil#sybil', :as => :sybil
  end
end
