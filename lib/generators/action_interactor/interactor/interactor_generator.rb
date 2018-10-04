# frozen_string_literal: true
module ActionInteractor
  module Generators
    class InteractorGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)

      def copy_interactor_file
        template "interactor.tt", File.join("app/interactors", class_path, "#{file_name}_interactor.rb")
      end
    end
  end
end
