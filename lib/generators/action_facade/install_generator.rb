# frozen_string_literal: true
module ActionFacade
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_application_facade_file
        template "application_facade.rb", File.join("app/facades/application_facade.rb")
      end
    end
  end
end
