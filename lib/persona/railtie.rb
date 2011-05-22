require 'rails'
require 'persona/controller'

module Persona
  class Railtie < Rails::Railtie
    
    initializer "persona.configure_routes" do |app|
      app.routes_reloader.paths << File.join(File.dirname(__FILE__), "..", "..", "rails", "routes.rb")
    end
    
    config.to_prepare do
      ApplicationController.class_eval do
        after_filter do
          if ['application', 'manage', 'manage_guest'].include?(_layout)
            @users = User.all.map { |u| {:id => u.id, :name => "#{u.owner_type}: #{u.name} - #{u.email}" }}
            response.body = response.body.insert(response.body.index('</body>'),ERB.new(File.read(File.dirname(__FILE__)+'/user_picker.html.erb')).result(binding))
          end
        end
      end
    end
  end
end