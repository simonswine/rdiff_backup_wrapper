require 'open3'

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
      output = {}

      command = [
        'nice',
        'ionice', '-c', '3',
      ] + cmd

      Open3.popen3(*command) do |i,o,e,t|
          output[:name] = config['name']
          output[:stdout] = o.read
          output[:stderr] = e.read
          output[:retval] = t.value
      end
      output
    end

    def cmd
      ['rdiff-backup', source, destination]
    end

    def to_s
      "<Backup name=#{config['name']}>"
    end
  end
end
