require 'rails'
require 'sybil/controller'

module Sybil
  class Railtie < Rails::Railtie
    config.sybil = ActiveSupport::OrderedOptions.new
    
    initializer "sybil.configure_routes" do |app|
      app.routes_reloader.paths << File.join(File.dirname(__FILE__), "..", "..", "rails", "routes.rb")
    end

    initializer 'sybil.set_default_options' do |app|
      options = app.config.sybil
      
      # templates - Array of string layout names that Sybil will inject into
      options.layouts ||= %w{application}
      
      # content_type - Regex that is matched against response.content_type to determine if Sybil should inject
      options.content_type ||= /text\/html/i
      
      # inject_before - Either a string or a pattern that Sybil will inject itself before the last occurance of in response.body
      options.inject_before ||= /<\/body>/i
      
      ## The following options can also be Hashes, in the form of '_layout' => Proc, so you can use a different proc for each layout ##
      
      # users - A proc that is run within the context of Sybil's ApplicationController :after_filter and returns any object that responds to #each
      # and returns objects that respond to #[:id] and #[:name] 
      # This means that you can simply do something like @users = User.all, if your Users have a :name attribute.
      # :id should be the id of the user, and :name will be what is displayed in Sybil's dropdown
      options.users ||= proc { User.all }
      
      # login - A proc that is run within the context of Sybil's #sybil action. Should log the user identified by params[:id] in.
      options.login ||= proc { UserSession.create(User.find(params[:id])) }
      
      # logout - A proc that is run within the context of Sybil's #sybil action (used when 'Guest' is selected). Should log the current user out.
      # Note: It is NOT guaranteed that this won't be called when the user is already logged out, therefore it is the developer's responsibility to account for that
      options.logout ||= proc { UserSession.find.destroy if UserSession.find }
      
      # Should return the current user session (needs to return false/nil if not logged in and respond to #id)
      options.current_user ||= proc { current_user }
    end
    
    config.to_prepare do
            
      ActionController::Base.class_eval do
        after_filter :inject_sybil
                
        private
        def inject_sybil
          if _layout and Rails.configuration.sybil.layouts.include?(_layout) and (response.content_type =~ Rails.configuration.sybil.content_type)
            @users = instance_eval(&(Rails.configuration.sybil.users.is_a?(Hash) ? Rails.configuration.sybil.users[_layout] : Rails.configuration.sybil.users))
            @current_user = instance_eval(&(Rails.configuration.sybil.current_user.is_a?(Hash) ? Rails.configuration.sybil.current_user[_layout] : Rails.configuration.sybil.current_user))
            @layout = _layout
            insert_index = response.body.rindex(Rails.configuration.sybil.inject_before)
            if insert_index
              response.body = response.body.insert(insert_index,ERB.new(File.read(File.join(File.dirname(__FILE__),'user_picker.html.erb'))).result(binding))
            else
              logger.warn "Sybil: Unable to match value of sybil.inject_before in response from #{params[:controller]}##{params[:action]}. Aborting."
            end
          end
        end
      end
      
    end
  end
end