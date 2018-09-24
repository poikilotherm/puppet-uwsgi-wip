require 'spec_helper'

describe 'uwsgi::app' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:hiera_config) { 'hiera.yaml' }
      let(:title) { 'test' }
      let(:params) do
        {
          'uid' => 'test',
          'gid' => 'test'
        }
      end

      context 'with parameters uid and gid' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('uwsgi') }

        case facts[:osfamily]
        when 'Debian'
          case facts[:operatingsystemmajrelease]
          when '7', '14.04'
            it do
              is_expected.to contain_file('/etc/uwsgi/apps-enabled/test.ini').
                with(
                  'ensure' => 'present',
                  'owner' => 'test',
                  'group' => 'test',
                  'mode' => '0640'
                )
            end
          else
            it do
              is_expected.to contain_file('/etc/uwsgi-emperor/vassals/test.ini').
                with(
                  'ensure' => 'present',
                  'owner' => 'test',
                  'group' => 'test',
                  'mode' => '0640'
                )
            end
          end
        when 'RedHat'
          it do
            is_expected.to contain_file('/etc/uwsgi.d/test.ini').
              with(
                'ensure' => 'present',
                'owner' => 'test',
                'group' => 'test',
                'mode' => '0640'
              )
          end
        end
      end
    end
  end
end
