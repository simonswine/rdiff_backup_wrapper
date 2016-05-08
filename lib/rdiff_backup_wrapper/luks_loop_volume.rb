
require 'open3'
require 'rdiff_backup_wrapper/volume'

module RdiffBackupWrapper
  class LuksLoopVolume < Volume
    def prepare_luks
      Open3.popen3("cryptsetup", "luksOpen", luks_source, luks_name) do |i, o, e ,t|
        i.puts "#{config['luksKey']}\n"
        i.close
        check_error(o, e, t)
      end
    end

    def cleanup_luks
      Open3.popen3("cryptsetup", "luksClose", luks_name) do |i, o, e ,t|
        check_error(o, e, t)
      end
    end

    def luks_name
      config['name']
    end

    def luks_source
      config['imagePath']
    end

    def luks_path
      File.join('/dev/mapper', luks_name)
    end

    def luks_exists?
      File.exists? luks_path
    end

    def mounted?
      Open3.popen3("mountpoint", "-q", config['mountPoint']) do |i, o, e ,t|
        if t.value.exitstatus == 0
          return true
        end
      end
      return false
    end

    def prepare_mount
      Open3.popen3("mount", luks_path, config['mountPoint']) do |i, o, e ,t|
        check_error(o, e, t)
      end
    end

    def cleanup_mount
      Open3.popen3("umount", config['mountPoint']) do |i, o, e ,t|
        check_error(o, e, t)
      end
    end

    def prepare
      prepare_luks
      prepare_mount
    end

    def cleanup
      if mounted?
        cleanup_mount
      end
      if luks_exists?
        cleanup_luks
      end
    end
  end
end
