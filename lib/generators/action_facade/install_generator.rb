# frozen_string_literal: true
module ActionFacade
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_application_facade_file
        template "app/facades/application_facade.rb"
      end

      def create_concerns_directory
        create_file "app/facades/concerns/.keep"
      end
    end
  end
end
