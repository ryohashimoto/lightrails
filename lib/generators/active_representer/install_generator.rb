# frozen_string_literal: true
module ActiveRepresenter
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_application_representer_file
        template "application_representer.rb", File.join("app/representers/application_representer.rb")
      end
    end
  end
end
