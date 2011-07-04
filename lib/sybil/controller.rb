module Sybil
  class Controller < ActionController::Base
    def sybil
      if params[:id] == 'logout'
        instance_eval(&(Rails.configuration.sybil.logout.is_a?(Hash) ? Rails.configuration.sybil.logout[params[:layout]] : Rails.configuration.sybil.logout))
      else
        instance_eval(&(Rails.configuration.sybil.login.is_a?(Hash) ? Rails.configuration.sybil.login[params[:layout]] : Rails.configuration.sybil.login))
      end
      params[:redirect] ? redirect_to(params[:redirect]) : render(:nothing => true)
    end
  end
end

::SybilController = Sybil::Controller