#!/usr/bin/env rspec

require 'spec_helper'

describe 'hp_mcp::repo', :type => 'class' do

  context 'on a non-supported operatingsystem' do
    let :facts do {
      :osfamily        => 'foo',
      :operatingsystem => 'foo',
      :operatingsystemrelease => '1'
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
        let(:params) {{}}
        let :facts do {
          :operatingsystem => os,
          :operatingsystemrelease => '6.0',
          :manufacturer    => 'foo'
        }
        end
        it { should_not contain_yumrepo('HP-mcp') }
      end
    end
  end

  context 'on a supported operatingsystem, HP platform, default parameters' do
    (['CentOS']).each do |os|
      context "for operatingsystem #{os}" do
        let(:params) {{}}
        let :facts do {
          :operatingsystem => os,
          :operatingsystemrelease => '6.0',
          :manufacturer    => 'HP'
        }
        end
        it { should contain_yumrepo('HP-mcp').with(
          :descr    => 'HP Software Delivery Repository for Management Component Pack',
          :enabled  => '1',
          :gpgcheck => '1',
          :gpgkey   => 'http://downloads.linux.hpe.com/SDR/hpPublicKey1024.pub
    http://downloads.linux.hpe.com/SDR/hpPublicKey2048.pub
    http://downloads.linux.hpe.com/SDR/hpPublicKey2048_key1.pub',
          :baseurl  => 'http://downloads.linux.hpe.com/SDR/repo/mcp/CentOS/$releasever/$basearch/current/',
          :priority => '50',
          :protect  => '0'
        )}
      end
    end
    (['OracleLinux', 'OEL']).each do |os|
      context "for operatingsystem #{os}" do
        let(:params) {{}}
        let :facts do {
          :operatingsystem => os,
          :operatingsystemrelease => '6.0',
          :manufacturer    => 'HP'
        }
        end
        it { should contain_yumrepo('HP-mcp').with(
          :descr    => 'HP Software Delivery Repository for Management Component Pack',
          :enabled  => '1',
          :gpgcheck => '1',
          :gpgkey   => 'http://downloads.linux.hpe.com/SDR/hpPublicKey1024.pub
    http://downloads.linux.hpe.com/SDR/hpPublicKey2048.pub
    http://downloads.linux.hpe.com/SDR/hpPublicKey2048_key1.pub',
          :baseurl  => 'http://downloads.linux.hpe.com/SDR/repo/mcp/Oracle/$releasever/$basearch/current/',
          :priority => '50',
          :protect  => '0'
        )}
      end
    end
  end

end
