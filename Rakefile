# frozen_string_literal: true

require "bundler/setup"
require "bundler/gem_tasks"
require "rake/testtask"
require "sdoc"
require "rdoc/task"

desc "Build all gems (lightrails, actionfacade, actioninteractor etc.)."
task :build_all do
  %w[actionfacade actioninteractor activerepresenter].each do |repository_name|
    Dir.chdir(repository_name) do
      sh "rake build"
    end
  end
  Rake::Task["build"].invoke
end

desc "Remove all built gems."
task :clean_all do
  %w[actionfacade actioninteractor activerepresenter].each do |repository_name|
    Dir.chdir(repository_name) do
      sh "rake clean"
    end
  end
  Rake::Task["clean"].invoke
end

desc "Push all built gems."
task :push_all do
  version = File.read(File.expand_path("VERSION", __dir__)).strip
  %w[actionfacade actioninteractor activerepresenter].each do |repository_name|
    Dir.chdir(repository_name) do
      sh "gem push pkg/#{repository_name}-#{version}.gem"
    end
  end
  sh "gem push pkg/lightrails-#{version}.gem"
end

Rake::TestTask.new { |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.warning = true
  t.verbose = true
  t.ruby_opts = ["--dev"] if defined?(JRUBY_VERSION)
}

FRAMEWORKS = %w(actionfacade actioninteractor activerepresenter)

%w(test test:isolated).each do |task_name|
  desc "Run #{task_name} task for all projects"
  task task_name do
    errors = []
    FRAMEWORKS.each do |project|
      system(%(cd #{project} && #{$0} #{task_name} --trace)) || errors << project
    end
    fail("Errors in #{errors.join(', ')}") unless errors.empty?
  end
end

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "doc"
  rdoc.options << "--format=sdoc"
  rdoc.options << "--exclude=\/(test|templates)\/"
  rdoc.template = "rails"
end

desc "Clean up (remove) doc directory."
task :clean_doc do
  sh "rm -rf doc/"
end
