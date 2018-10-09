# frozen_string_literal: true

module ActiveRepresenter
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_application_representer_file
        template "app/representers/application_representer.rb"
      end

      def create_concerns_directory
        create_file "app/representers/concerns/.keep"
      end
    end
  end
end
