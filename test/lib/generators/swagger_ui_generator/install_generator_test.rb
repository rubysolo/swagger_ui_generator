require 'test_helper'
require 'generators/swagger_ui_generator/install/install_generator'
require 'nokogiri'

class InstallGeneratorTest < Rails::Generators::TestCase
  tests SwaggerUiGenerator::Generators::InstallGenerator
  destination Rails.root

  setup :prepare_destination

  test "generates swagger ui app" do
    run_generator

    assert_file "public/swagger/swagger-ui.js"
    assert_file "public/api-docs.html", %r{/swagger/swagger-ui.js}

    css_files = %w(
      highlight.default.css
      screen.css
    )

    css_files.each do |css|
      assert_file "public/swagger/css/#{ css }"
      assert_file "public/api-docs.html", %r{/swagger/css/#{ css }}
    end

    js_files = %w(
      shred.bundle.js
      jquery-1.8.0.min.js
      jquery.slideto.min.js
      jquery.wiggle.min.js
      jquery.ba-bbq.min.js
      handlebars-1.0.0.js
      underscore-min.js
      backbone-min.js
      swagger.js
      highlight.7.3.pack.js
    )

    js_files.each do |js|
      assert_file "public/swagger/lib/#{ js }"
      assert_file "public/api-docs.html", %r{/swagger/lib/#{ js }}
    end
  end

  test "uses default location for @api_spec_path" do
    run_generator
    assert_file "public/api-docs.html", %r{window\.location\.host \+ "/swagger/api-docs.json"}
  end

  test "uses custom location for @api_spec_path" do
    run_generator %w(--api-spec-path /api/v2/docs.json)
    assert_file "public/api-docs.html", %r{window\.location\.host \+ "/api/v2/docs.json"}
  end

  test "does not modify font stylesheet" do
    run_generator
    assert_file "public/api-docs.html" do |html|
      doc = Nokogiri::HTML(html)
      css_hrefs = (doc / 'link[rel="stylesheet"]').map { |el| el['href'] }
      font_href = css_hrefs.reject { |href| href.start_with? '/swagger' }.first

      assert font_href
      assert_equal 'https://fonts.googleapis.com/css?family=Droid+Sans:400,700', font_href
    end
  end

  test 'imports the throbber gif and modifies the path appropriately' do
    run_generator
    assert_file "public/swagger/throbber.gif"
    assert_file "public/swagger/swagger-ui.js", %r{'/swagger/throbber.gif'}
  end
end
