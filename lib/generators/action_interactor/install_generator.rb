# frozen_string_literal: true
module ActionInteractor
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_application_interactor_file
        template "application_interactor.rb", File.join("app/interactors/application_interactor.rb")
      end
    end
  end
end
