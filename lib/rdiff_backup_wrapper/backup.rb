module RdiffBackupWrapper
  class Backup
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def source
      ensure_slash_end('source')
    end

    def destination
      ensure_slash_end('destination')
    end

    def ensure_slash_end(key)
      if config[key].end_with? '/'
        return config[key]
      end
      config[key] + '/'
    end

    def run
      command = [
        'nice',
        'ionice', '-c', '3',
      ] + cmd
      Open3.popen3(command) do |i,o,e,t|
          p o.read
          p e.read
      end
    end

    def cmd
      ['rdiff-backup', source, destination]
    end

    def to_s
      "<Backup name=#{config['name']}>"
    end
  end
end
