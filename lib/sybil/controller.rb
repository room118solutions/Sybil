module Sybil
  class Controller < ActionController::Base
    def login
      instance_eval(&Rails.configuration.sybil.login)
      render :nothing => true
    end
    
    def logout
      instance_eval(&Rails.configuration.sybil.logout)
      render :nothing => true
    end
  end
end

::SybilController = Sybil::Controller