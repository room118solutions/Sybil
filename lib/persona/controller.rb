module Persona
  class Controller < ActionController::Base
    def login
      UserSession.create(User.find(params[:id]))
      render :nothing => true
    end
    
    def logout
      UserSession.find.destroy
      render :nothing => true
    end
  end
end

::PersonaController = Persona::Controller