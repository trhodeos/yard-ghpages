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

      def initialize
        base = Dir.pwd
        gemspecs = Dir[File.join(base, "{,*}.gemspec")]
        raise "Unable to determine name from existing gemspec. Use :name => 'gemname' in #install_tasks to manually set it." unless gemspecs.size == 1
        @spec_path = gemspecs.first
        @gemspec = Bundler.load_gemspec(@spec_path)
      end

      def install(opts)
        namespace :yard do
          desc 'build yard documentation'
          task :build do |t|
            YARD::CLI::Yardoc.run(*opts)
          end

          desc 'publish documentation to gh-pages'
          task :publish do |t|
            grancher = Yard::GHPages::BranchMerger.new do |g|
              g.source = { branch: 'master', directory: 'doc' }
              g.destination = { branch: 'gh-pages', directory: '.' }
              g.message = 'Updated website' # defaults to 'Updated files.'
            end
          end
        end
      end
    end
  end
end
