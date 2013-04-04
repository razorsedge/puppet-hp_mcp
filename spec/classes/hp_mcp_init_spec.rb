#!/usr/bin/env rspec

require 'spec_helper'

describe 'hp_mcp', :type => 'class' do

  context 'on a non-supported operatingsystem' do
    let :facts do {
      :osfamily        => 'foo',
      :operatingsystem => 'foo'
    }
    end
    it 'should fail' do
      expect {
        should raise_error(Puppet::Error, /Unsupported osfamily: foo operatingsystem: foo, module hp_mcp only support operatingsystem/)
      }
    end
  end

  redhatish = ['CentOS', 'OracleLinux', 'OEL']

  context 'on a supported operatingsystem, non-HP platform' do
    redhatish.each do |os|
      context "for operatingsystem #{os}" do
        let(:params) {{ :cmalocalhostrwcommstr => 'aString' }}
        let :facts do {
          :operatingsystem => os,
          :manufacturer    => 'foo'
        }
        end
        it { should_not contain_anchor('hp_mcp::begin') }
        it { should_not contain_class('hp_mcp::repo') }
        it { should_not contain_class('hp_mcp::hphealth') }
        it { should_not contain_class('hp_mcp::hpsnmp') }
        it { should_not contain_class('hp_mcp::hpsmh') }
        it { should_not contain_anchor('hp_mcp::end') }
        it { should_not contain_class('hp_mcp::hpams') }
      end
    end
  end

  context 'on a supported operatingsystem, HP platform, default parameters' do
    redhatish.each do |os|
      context "for operatingsystem #{os}" do
        let(:params) {{ :cmalocalhostrwcommstr => 'aString' }}
        let :facts do {
          :operatingsystem => os,
          :manufacturer    => 'HP'
        }
        end
        it { should contain_anchor('hp_mcp::begin') }
        it { should contain_class('hp_mcp::repo') }
        it { should contain_class('hp_mcp::hphealth') }
        it { should contain_class('hp_mcp::hpsnmp') }
        it { should contain_class('hp_mcp::hpsmh') }
        it { should contain_anchor('hp_mcp::end') }
        it { should_not contain_class('hp_mcp::hpams') }
      end
    end
  end

end
