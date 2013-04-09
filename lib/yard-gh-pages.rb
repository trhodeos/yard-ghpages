require 'yard-gh-pages/version'

require 'yard'
require 'grancher'


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

          desc 'deploy yard documentation to gh-pages'
          task :deploy do |t|
            grancher = Grancher.new do |g|
              g.branch = 'gh-pages'
              g.push_to = 'origin'
              g.message = 'Updated documentation'

              g.directory 'doc', '.'
            end

            grancher.commit
      #      grancher.push
          end
        end
      end
    end
  end
end
