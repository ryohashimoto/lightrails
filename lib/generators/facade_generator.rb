# frozen_string_literal: true
module Rails
  module Generators
    class FacadeGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)

      def copy_facade_file
        template "facade.tt", File.join("app/facades", class_path, "#{file_name}_facade.rb")
      end
    end
  end
end
