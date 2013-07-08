require 'git'

module Yard::GHPages
  class BranchMerger
    attr_accessor :source, :destination, :message
    def initialize(opts = {}, &block)
      opts.each { |k, v| self.send("#{k.to_s}=", v) }
      yield(self) if block_given?
    end

    def merge
      git.reset
      source_tree = git.gtree("HEAD^{#{source[:branch]}}:#{source[:directory]}")

      logger.warn(source_tree)
    end

    private
    def git
      @g ||= Git.open(working_dir, logger)
      raise Exception.new("#{working_dir} not a valid git repository.") unless @g.index and @g.index.readable?
    end

    def working_dir
      Dir.pwd
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
