# frozen_string_literal: true
module ActionInteractor
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_application_interactor_file
        template "app/interactors/application_interactor.rb"
      end

      def create_concerns_directory
        create_file "app/interactors/concerns/.keep"
      end
    end
  end
end
