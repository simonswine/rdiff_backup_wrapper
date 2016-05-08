require 'rdiff_backup_wrapper/luks_loop_volume'

module RdiffBackupWrapper
  class Volume
    def self.create(config)
      if config['type'] == 'luks-loop'
        LuksLoopVolume.new config
      else
        raise "Unknown volume type '#{config['type']}"
      end
    end

    attr_reader :config

    def initialize(config)
      @config = config
    end

    def check_error(o, e, t)
      return if t.value.exitstatus == 0
      STDERR.puts e.read
      STDERR.puts o.read
      STDERR.puts t
      raise "error"
    end
  end
end
