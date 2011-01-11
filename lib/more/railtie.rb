class Less::More # :nodoc:
  if defined? Rails::Railtie
    class Railtie < ::Rails::Railtie
      initializer 'more.insert_into_action_controller' do
        ActiveSupport.on_load(:action_controller) do
          Less::More::Railtie.insert
        end
      end

      rake_tasks do
        load 'tasks/more_tasks.rake'
      end
    end
  end

  class Railtie
    def self.insert
      require 'more/controller_extension' if Rails.env.development?
    end
  end
end
