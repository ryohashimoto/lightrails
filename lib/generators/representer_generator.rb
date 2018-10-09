# frozen_string_literal: true

module Rails
  module Generators
    class RepresenterGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)

      def copy_representer_file
        template "representer.tt", File.join("app/representers", class_path, "#{file_name}_representer.rb")
      end
    end
  end
end
