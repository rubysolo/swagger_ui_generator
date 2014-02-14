require 'rails/generators'

module SwaggerUiGenerator
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc 'Generate Swagger UI API documentation viewer'
      source_root ::File.expand_path('../templates', __FILE__)

      class_option :title, type: :string, aliases: "-t", desc: "Title for the API Docs page", default: "API Docs"
      class_option :api_spec_path, type: :string, aliases: "-p", desc: "Path to Swagger JSON API spec", default: "/swagger/api-docs.json"

      def copy_lib
        @title         = options[:title]
        @api_spec_path = options[:api_spec_path]

        template  "public/api-docs.html.erb",     "public/api-docs.html"
        copy_file "public/swagger/swagger-ui.js", "public/swagger/swagger-ui.js"
        directory "public/swagger"
      end
    end
  end
end
