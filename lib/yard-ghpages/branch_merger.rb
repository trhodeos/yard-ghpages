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
      source_tree = sha source[:branch], source[:directory]
      raise Exception.new("Could not find source #{source}") unless source_tree

      dest_commit = head_commit(destination[:branch])

      commit = git.commit_tree(source_tree, message: message, parents: dest_commit || nil )

      git.update_ref("refs/heads/#{destination[:branch]}",commit)

    end

    private
    def git
      @g ||= Git.open(working_dir, :log => logger).tap do |g|
        raise Exception.new("#{working_dir} not a valid git repository.") unless g.index and g.index.readable?
      end
    end

    def head_commit branch
      begin
        git.branch(branch).gcommit.tap do |c|
          logger.debug("FOR #{branch}: #{c}")
        end
      rescue
        logger.warn("No commit for #{branch} found.")
        nil
      end
    end

    def sha *opts
      begin
        git.revparse(opts.join(":")).tap do |t|
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
