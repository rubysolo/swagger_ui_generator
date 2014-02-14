require 'fileutils'
require 'nokogiri'

module SwaggerUiGenerator
  class Importer
    def import
      cleanup
      ensure_directory_structure
      copy_dependencies
      generate_template
    end

    def cleanup
      FileUtils.rm_rf Dir[destination_path("**/*")]
    end

    def ensure_directory_structure
      FileUtils.mkdir_p destination_path("public/swagger")
    end

    def copy_dependencies
      generate_script_with_custom_throbber_path

      %w( lib css ).each do |dir|
        src = source_path("#{ dir }/*")
        dst = destination_path("public/swagger/#{ dir }")

        FileUtils.mkdir_p dst
        FileUtils.cp_r Dir[src], dst
      end

      FileUtils.cp source_path("images/throbber.gif"), destination_path("public/swagger")
    end

    def generate_script_with_custom_throbber_path
      script = IO.read(source_path('swagger-ui.js')).gsub(%r{'images/throbber.gif'}, "'/swagger/throbber.gif'")
      File.open(destination_path("public/swagger/swagger-ui.js"), 'w') do |js|
        js.write script
      end
    end

    def generate_template
      ui_doc.at('title').content = "__@title__"

      script_el = ui_doc.at('script:not([src])')
      script = script_el.content.split(/\n/).map do |line|
        if line =~ /url:\s*"http/
          '      url: window.location.protocol + "//" + window.location.host + "__@api_spec_path__",'
        else
          line
        end
      end
      script_el.native_content = script.join("\n")

      (ui_doc / 'script[src]').each do |el|
        el['src'] = "/swagger/#{ el['src'] }"
      end

      (ui_doc / 'link[rel="stylesheet"]').each do |el|
        el['href'] = "/swagger/#{ el['href'] }" if el['href'].start_with? 'css'
      end

      ui_doc.at('a#logo').remove
      (ui_doc / 'form#api_selector .icon-btn').each { |el| el.remove }

      File.open(destination_path("public/api-docs.html.erb"), 'w') do |out|
        out.write ui_doc.to_xhtml(indent:2, indent_text:" ").gsub(/__(.*)__/, '<%= \1 %>')
      end
    end

    def source_path(path)
      source_base.join(path)
    end

    def destination_path(path)
      destination_base.join(path)
    end

    private

    def ui_doc
      @ui_doc ||= Nokogiri::HTML(IO.read(source_path("index.html")).gsub("\r\n", "\n"))
    end

    def source_base
      @src ||= relative_path("../../../vendor/swagger-ui/dist")
    end

    def destination_base
      @dst ||= relative_path("../../generators/swagger_ui_generator/install/templates")
    end

    def relative_path(path)
      Pathname.new(File.expand_path(path, __FILE__))
    end
  end
end
