# frozen_string_literal: true
module Lightrails
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_lightrails_initializer_file
        template "lightrails.rb", File.join("config/initializers/lightrails.rb")
      end

      def invoke_other_generators
        invoke "action_facade:install"
        invoke "action_interactor:install"
        invoke "active_representer:install"
      end
    end
  end
end
