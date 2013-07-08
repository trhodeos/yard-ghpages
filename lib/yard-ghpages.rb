require 'yard-ghpages/version'
require 'yard-ghpages/branch_merger'

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
            Yard::GHPages::BranchMerger.new do |g|
              g.source = { branch: 'master', directory: 'doc' }
              g.destination = { branch: 'gh-pages'}
              g.message = 'Updated website' # defaults to 'Updated files.'
            end.merge.push
          end
        end
      end
    end
  end
end
