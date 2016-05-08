require "rdiff_backup_wrapper/version"
require "rdiff_backup_wrapper/backup"
require 'yaml'

module RdiffBackupWrapper
  class RdiffBackupWrapper
    def initialize(config_path=nil)
      @config_path = config_path
    end

    def config_path
      @config_path || '/etc/rdiff-backup-wrapper.yml'
    end

    def config
      YAML::load_file(config_path)
    end

    def backups
      unless @backups.nil?
        return @backups
      end
      @backups = []
      config.each do |backup_config|
        @backups << Backup.new(backup_config)
      end
      @backups
    end

    def run
      outputs = []
      backups.each do |backup|
        outputs << backup.run
      end

      retval = 0

      outputs.each do |o|
        if o[:retval].exitstatus != 0
          retval = 1
          STDERR.puts "backup #{o[:name]} failed with exitstatus #{o[:retval].exitstatus}"
          [:stderr, :stdout].each do |k|
            if o[k].length > 0
              STDERR.puts "output #{k}:"
              STDERR.puts o[k]
            end
          end
        end
      end
      exit retval
    end
  end
end
