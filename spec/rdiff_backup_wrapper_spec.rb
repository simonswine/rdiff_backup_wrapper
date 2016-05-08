require 'spec_helper'
require 'yaml'

describe RdiffBackupWrapper do
  let :rdw do
    RdiffBackupWrapper::RdiffBackupWrapper.new config_path
  end

  let :config_path do
    file = Tempfile.new('foo')
    file.write config.to_yaml
    file.close
    file.path
  end

  let :config do
    [
      {
        'name' => 'backup1',
        'source' => 'source1',
        'destination' => 'destination1',
        'keep_days': 10,
      },
      {
        'name' => 'backup2',
        'source' => 'source2',
        'destination' => 'destination2',
        'keep_days': 11,
      },
    ]
  end

  it 'has a version number' do
    expect(RdiffBackupWrapper::VERSION).not_to be nil
  end

  describe '#config' do
    it 'returns a valid config' do
      expect(rdw.config).to eq(config)
    end
  end

  describe '#backups' do
    it 'returns 2 backup objects' do
      expect(rdw.backups.length).to eq(2)
    end

    it 'return correct 2 backup commands' do
      rdw.backups.each do |backup|
        cmd = backup.cmd
        expect(cmd[0]).to eq('rdiff-backup')
        expect(cmd[1][-1]).to eq('/')
        expect(cmd[2][-1]).to eq('/')
      end
    end
  end
end
