require 'spec_helper'

describe Gricer::Parsers::Request do
  let(:header) {{
    'HTTP_USER_AGENT' => 'My great browser',
    'HTTP_REFERER' => 'http://gmah.net/',
    'HTTP_ACCEPT_LANGUAGE' => 'de-de'
  }}
  let(:request) { mock('ActionController::AbstractRequest') }
  
  before do
    request.stub(:remote_ip) { '127.0.0.1' }
    request.stub(:headers) { header }
    request.stub(:host) { 'gricer.org' }
    request.stub(:path) { '/demo' }
    request.stub(:request_method) { 'GET' }
    request.stub(:protocol) { 'https://' }
    I18n.stub(:locale) { :de }
  end
  
  it "parses simple request fields" do
    info = Gricer::Parsers::Request.get_info request
  
    info[:ip_address].should == '127.0.0.1'
    info[:agent_header].should == 'My great browser'
    info[:referer].should == 'http://gmah.net/'
    info[:host].should == 'gricer.org'
    info[:path].should == '/demo'
    info[:method].should == 'GET'
    info[:protocol].should == 'HTTPS'
    info[:locale].should == :de
    info[:req_locale].should == 'de-de'
  end                
  
  context 'req_locale' do
    it "handles simple locale requests" do
      header['HTTP_ACCEPT_LANGUAGE'] = "cn, fr, en"
      info = Gricer::Parsers::Request.get_info request
      info[:req_locale].should == 'cn'
    end
    
    it "handles locale request with quality values" do
      header['HTTP_ACCEPT_LANGUAGE'] = "da, en-gb;q=0.8, en;q=0.7"
      info = Gricer::Parsers::Request.get_info request
      info[:req_locale].should == 'da'
    end
    
    it "handles not set requested locale" do
      header['HTTP_ACCEPT_LANGUAGE'] = nil
      info = Gricer::Parsers::Request.get_info request
      info[:req_locale].should be_nil
    end
    
    it "handles malformed locale requests (1)" do
      header['HTTP_ACCEPT_LANGUAGE'] = "Accept-Language:ru,en-us;q=0.7,en;q=0.3"
      info = Gricer::Parsers::Request.get_info request
      info[:req_locale].should == 'ru'
    end
    
    it "handles malformed locale requests (2)" do
      header['HTTP_ACCEPT_LANGUAGE'] = "es-419,es;q=0.8"
      info = Gricer::Parsers::Request.get_info request
      info[:req_locale].should == 'es'
    end
    
    it "handles malformed locale requests (3)" do
      header['HTTP_ACCEPT_LANGUAGE'] = "sr-Latn-RS"
      info = Gricer::Parsers::Request.get_info request
      info[:req_locale].should == 'sr'
    end
    
    it "handles malformed locale requests (4)" do
      header['HTTP_ACCEPT_LANGUAGE'] = "x-ns1pyqY5zCLNxx,x-ns2V13MxcVGQb2"
      info = Gricer::Parsers::Request.get_info request
      info[:req_locale].should be_nil
    end
  end  
  
  # def self.get_info(request)  
  #   info = {}
  #   
  #   info[:ip_address]   = request.remote_ip
  #   info[:agent_header] = request.headers['HTTP_USER_AGENT']
  #   info[:referer]      = request.headers['HTTP_X_FORWARDED_REFERER'] || request.headers['HTTP_REFERER']
  # 
  #   info[:host]         = request.host
  #   info[:path]         = request.path
  #   info[:method]       = request.request_method
  #   info[:protocol]     = request.protocol.sub(/[:\/]*$/, '').upcase
  #   info[:locale]       = I18n.locale
  # 
  #   info[:req_locale]   = request.headers['HTTP_ACCEPT_LANGUAGE'].try(:scan, /[^,;]+/).try(:first)
  # 
  #   return info
  # end
end
