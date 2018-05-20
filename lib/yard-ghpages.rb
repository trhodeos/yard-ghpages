require 'yard-ghpages/version'
require 'yard-ghpages/branch_merger'

require 'yaml'
require 'yard'

module Yard
  module GHPages
    class Tasks
      include Rake::DSL if defined? Rake::DSL

      class << self
        def install_tasks(opts = {})
          new.install(opts)
        end
      end

      def install(opts)
        namespace :yard do
          desc 'Build yard documentation'
          task :build do |t|
            YARD::CLI::Yardoc.run(*opts)
          end

          desc 'Publish documentation to gh-pages'
          task :publish do |t|
            source_branch = 'master'
            source_directory = 'docs'
            destination_branch = 'gh-pages' 

            config_filename = '.yard-gh-pages.yml'
            if File.file?(config_filename)
              config_file = YAML.load_file(config_filename)
              source_branch = config_file.fetch('source_branch', source_branch)
              source_directory = config_file.fetch('source_directory', source_directory)
              destination_branch = config_file.fetch('destination_branch', destination_branch)
            end
            Yard::GHPages::BranchMerger.new do |g|
              g.source = { branch: source_branch, directory: source_directory }
              g.destination = { branch: destination_branch }
              g.message = 'Updated website' # defaults to 'Updated files.'
            end.merge.push
          end
        end
      end
    end
  end
end
