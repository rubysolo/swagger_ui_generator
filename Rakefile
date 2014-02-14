require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

task default: :test


namespace :swagger do
  require 'swagger_ui_generator/importer'

  task :update do
    SwaggerUiGenerator::Importer.new.import
  end

  task :cleanup do
    SwaggerUiGenerator::Importer.new.cleanup
  end
end
