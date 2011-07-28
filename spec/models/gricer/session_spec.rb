require 'spec_helper'

describe Gricer::Session do

  context 'IP' do    
    it 'should fill ip address hash' do
      subject.ip_address = '127.0.0.1'
      
      subject.ip_address_hash.should == '4b84b15bff6ee5796152495a230e45e3d7e947d9'
    end
  
    it 'should fill anonyminized domain' do
      Resolv.should_receive(:getname).with('127.0.0.1') { 'some.real.host.gmah.net' }
      
      subject.ip_address = '127.0.0.1'
      
      subject.domain.should == 'gmah.net'
    end
    
    it 'should fill anonyminized domain in uk' do
      Resolv.should_receive(:getname).with('127.0.0.1') { 'some.real.host.the-queen.co.uk' }
      
      subject.ip_address = '127.0.0.1'
      
      subject.domain.should == 'the-queen.co.uk'
    end
    
    it 'should fill IP if resolve fails' do
      Resolv.should_receive(:getname).with('127.0.0.1') { throw 'IP not found' }
      
      subject.ip_address = '127.0.0.1'
      
      subject.domain.should == '127.0.x.x'
    end
    
    context 'No GeoIP' do
      it 'should not fill country' do
        subject.ip_address = '127.0.0.1'
        subject.country.should be_nil
      end 
      
      it 'should not fill region' do
        subject.ip_address = '127.0.0.1'
        subject.region.should be_nil
      end
      
      it 'should not fill city' do
        subject.ip_address = '127.0.0.1'
        subject.city.should be_nil
      end
      
      it 'should not fill postal code' do
        subject.ip_address = '127.0.0.1'
        subject.postal_code.should be_nil
      end

      it 'should not fill longitude' do   
        subject.ip_address = '127.0.0.1'
        subject.longitude.should be_nil
      end
          
      it 'should not fill latitude' do
        subject.ip_address = '127.0.0.1'
        subject.latitude.should be_nil
      end
    end
  
    context 'GeoIP City' do
      before do
        Gricer.config.geoip_db = mock(:GeoIP)
        Gricer.config.geoip_db.stub(:look_up).with('127.0.0.1') { {:country_code=>"DE", :country_code3=>"DEU", :country_name=>"Germany", :region=>"16", :city=>"Berlin", :postal_code=>"10115", :latitude=>52.516700744628906, :longitude=>13.399999618530273} }
      end
      
      it 'should fill country' do
        subject.ip_address = '127.0.0.1'
        subject.country.should == 'de'
      end 
      
      it 'should fill region' do
        subject.ip_address = '127.0.0.1'
        subject.region.should == '16'
      end
      
      it 'should fill city' do
        subject.ip_address = '127.0.0.1'
        subject.city.should == 'Berlin'
      end
      
      it 'should fill postal code' do
        subject.ip_address = '127.0.0.1'
        subject.postal_code.should == '10115'
      end

      it 'should fill longitude' do   
        subject.ip_address = '127.0.0.1'
        subject.longitude.should == 13.399999618530273
      end
          
      it 'should fill latitude' do
        subject.ip_address = '127.0.0.1'
        subject.latitude.should == 52.516700744628906
      end
    end
    
    context 'GeoIP Country' do
      before do
        Gricer.config.geoip_db = mock(:GeoIP)
        Gricer.config.geoip_db.stub(:look_up).with('127.0.0.1') { {:country_code=>"DE", :country_code3=>"DEU", :country_name=>"Germany", :latitude=>51.0, :longitude=>9.0} }
      end
      
      it 'should fill country' do
        subject.ip_address = '127.0.0.1'
        subject.country.should == 'de'
      end 
      
      it 'should not fill region' do
        subject.ip_address = '127.0.0.1'
        subject.region.should be_nil
      end
      
      it 'should not fill city' do
        subject.ip_address = '127.0.0.1'
        subject.city.should be_nil
      end
      
      it 'should not fill postal code' do
        subject.ip_address = '127.0.0.1'
        subject.postal_code.should be_nil
      end

      it 'should fill longitude' do   
        subject.ip_address = '127.0.0.1'
        subject.longitude.should == 9.0
      end
          
      it 'should fill latitude' do
        subject.ip_address = '127.0.0.1'
        subject.latitude.should == 51.0
      end
    end
    
    context 'GeoIP unknown address' do
      before do
        Gricer.config.geoip_db = mock(:GeoIP)
        Gricer.config.geoip_db.stub(:look_up).with('127.0.0.1') { nil }
      end
      
      it 'should not fill country' do
        subject.ip_address = '127.0.0.1'
        subject.country.should be_nil
      end 
      
      it 'should not fill region' do
        subject.ip_address = '127.0.0.1'
        subject.region.should be_nil
      end
      
      it 'should not fill city' do
        subject.ip_address = '127.0.0.1'
        subject.city.should be_nil
      end
      
      it 'should not fill postal code' do
        subject.ip_address = '127.0.0.1'
        subject.postal_code.should be_nil
      end

      it 'should not fill longitude' do   
        subject.ip_address = '127.0.0.1'
        subject.longitude.should be_nil
      end
          
      it 'should not fill latitude' do
        subject.ip_address = '127.0.0.1'
        subject.latitude.should be_nil
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
end