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
      
      # users - A proc that is run within the context of Sybil's ApplicationController :after_filter and returns any object that responds to #each
      # and returns objects that respond to #[:id] and #[:name] 
      # This means that you can simply do something like @users = User.all, if your Users have a :name attribute.
      # :id should be the id of the user, and :name will be what is displayed in Sybil's dropdown
      options.users ||= proc { User.all }
      
      # login - A proc that is run within the context of Sybil's #login action. Should log the user identified by params[:id] in.
      options.login ||= proc { UserSession.create(User.find(params[:id])) }
      
      # logout - A proc that is run within the context of Sybil's #logout action (used when 'Guest' is selected). Should log the current user out.
      options.logout ||= proc { UserSession.find.destroy }
    end
    
    config.to_prepare do
            
      ApplicationController.class_eval do
        after_filter :inject_sybil
        
        private
        def inject_sybil
          if Rails.configuration.sybil.layouts.include?(_layout) and (response.content_type =~ Rails.configuration.sybil.content_type)
            @users = instance_eval(&Rails.configuration.sybil.users)
            response.body = response.body.insert(response.body.rindex(Rails.configuration.sybil.inject_before),ERB.new(File.read(File.join(File.dirname(__FILE__),'user_picker.html.erb'))).result(binding))
          end
        end
      end
      
    end
  end
end