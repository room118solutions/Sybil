require 'rails'
require 'sybil/controller'

module Sybil
  class Railtie < Rails::Railtie
    
    initializer "sybil.configure_routes" do |app|
      app.routes_reloader.paths << File.join(File.dirname(__FILE__), "..", "..", "rails", "routes.rb")
    end
    
    config.to_prepare do
      ApplicationController.class_eval do
        after_filter :inject_sybil
        
        private
        def inject_sybil
          # TODO: Move templates to config
          if ['application', 'manage', 'manage_guest'].include?(_layout)
            
            # TODO: move this to config
            # @users must be set to anything that responds to #each and returns objects that respond to #[:id] and #[:name] 
            # this means that you can simply do something like @users = User.all, if your Users have a :name attribute.
            @users = User.all.map { |u| {:id => u.id, :name => "#{u.owner_type}: #{u.name} - #{u.email}" }}
            response.body = response.body.insert(response.body.index('</body>'),ERB.new(File.read(File.dirname(__FILE__)+'/user_picker.html.erb')).result(binding))
          end
        end
      end
    end
  end
end