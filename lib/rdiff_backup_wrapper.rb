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
      backups.each do |backup|
        backup.run
      end
    end
  end
end
