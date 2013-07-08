require 'git'

require 'logger'

module Yard::GHPages
  class BranchMerger
    attr_accessor :source, :destination, :message
    def initialize(opts = {}, &block)
      opts.each { |k, v| self.send("#{k.to_s}=", v) }
      yield(self) if block_given?
    end

    def merge
      git.reset
      source_tree = get_sha source[:branch], source[:directory]
      raise Exception.new("Could not find source #{source}") unless source_tree

      dest_tree = get_sha destination[:branch], destination[:directory]

      commit = git.commit_tree(source_tree, message: message, parents: dest_tree || nil )

      git.update_ref("refs/heads/#{destination[:branch]}",commit)

    end

    private
    def git
      @g ||= Git.open(working_dir, :log => logger).tap do |g|
        raise Exception.new("#{working_dir} not a valid git repository.") unless g.index and g.index.readable?
      end
    end

    def get_sha *opts
      begin
        git.revparse(":".join(opts)).tap do |t|
          logger.debug("FOR #{opts}: #{t}")
        end
      rescue
        logger.warn("No sha for #{opts} found.")
        nil
      end
    end

    def working_dir
      Dir.pwd
    end

    def logger
      @logger ||= Logger.new(STDOUT).tap { |l| l.level = Logger::WARN }
    end
  end
end
