require 'spec_helper'

describe Gricer::Session do

  context 'IP' do    
    it 'should get IP info from parser' do
      Gricer::Parsers::Ip.should_receive(:get_info).with('127.0.0.1') do 
        {
          ip_address_hash: '4b84b15bff6ee5796152495a230e45e3d7e947d9',
          domain: 'x.top.secret',
          country: 'de',
          region: '16',
          city: 'Berlin',
          postal_code: '10115',
          longitude: 13.399999618530273,
          latitude: 52.516700744628906
        }
      end
      
      subject.ip_address = '127.0.0.1'
      
      subject.ip_address_hash.should == '4b84b15bff6ee5796152495a230e45e3d7e947d9'
      subject.domain.should == 'x.top.secret'
      subject.country.should == 'de'
      subject.region.should == '16'
      subject.city.should == 'Berlin'
      subject.postal_code.should == '10115'
      subject.longitude.should == 13.399999618530273
      subject.latitude.should == 52.516700744628906
    end
  end
    
  context 'Requested Locale' do
    it 'should parse simple locale' do
      subject.requested_locale = 'de'
      subject.requested_locale_major.should == 'de'
      subject.requested_locale_minor.should == nil
      subject.requested_locale.should == 'de'
    end
  
    it 'should parse complex locale' do
      subject.requested_locale = 'de-at'
      subject.requested_locale_major.should == 'de'
      subject.requested_locale_minor.should == 'at'
      subject.requested_locale.should == 'de-at'
    end
  
    it 'should parse complex locale with upcase minor' do
      subject.requested_locale = 'de-AT'
      subject.requested_locale_major.should == 'de'
      subject.requested_locale_minor.should == 'at'
      subject.requested_locale.should == 'de-at'
    end
  
    it 'should parse not given locale' do
      subject.requested_locale = nil
      subject.requested_locale_major.should == nil
      subject.requested_locale_minor.should == nil
      subject.requested_locale.should == nil
    end
  end
end