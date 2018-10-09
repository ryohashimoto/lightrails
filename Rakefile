# frozen_string_literal: true
require "bundler/setup"
require "bundler/gem_tasks"

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
