require "rdiff_backup_wrapper/version"
require "rdiff_backup_wrapper/backup"
require "rdiff_backup_wrapper/luks_loop_volume"
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
      config['backups'].each do |backup_config|
        @backups << Backup.new(backup_config)
      end
      @backups
    end

    def volumes
      unless @volumes.nil?
        return @volumes
      end
      @volumes = []
      config['volumes'].each do |volume_config|
        @volumes << Volume.create(volume_config)
      end
      @volumes
    end

    def prepare_volumes
      volumes.each do |v|
        v.prepare
      end
    end

    def cleanup_volumes
      volumes.each do |v|
        v.cleanup
      end
    end

    def run
      at_exit do
        cleanup_volumes
      end
      prepare_volumes
      ret_val = run_backups
      exit ret_val
    end

    def run_backups
      retval = 0

      outputs = []
      backups.each do |backup|
        outputs << backup.run
      end

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

      return retval
    end
  end
end
