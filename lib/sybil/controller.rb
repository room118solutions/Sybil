module Sybil
  class Controller < ActionController::Base
    def login
      # TODO: Allow config override
      UserSession.create(User.find(params[:id]))
      render :nothing => true
    end
    
    def logout
      # TODO: Allow config override
      UserSession.find.destroy
      render :nothing => true
    end
  end
end

::SybilController = Sybil::Controller