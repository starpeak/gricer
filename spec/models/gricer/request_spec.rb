require 'spec_helper'

describe Gricer::Request do
  context 'set ip_address' do
    it 'should set an ip address' do
      subject.ip_address = '127.0.0.1'
    end
  end
  
  context 'Locale' do
    it 'should parse simple locale' do
      subject.locale = 'de'
      subject.locale_major.should == 'de'
      subject.locale_minor.should == nil
      subject.locale.should == 'de'
    end
  
    it 'should parse complex locale' do
      subject.locale = 'de-at'
      subject.locale_major.should == 'de'
      subject.locale_minor.should == 'at'
      subject.locale.should == 'de-at'
    end
  
    it 'should parse complex locale with upcase minor' do
      subject.locale = 'de-AT'
      subject.locale_major.should == 'de'
      subject.locale_minor.should == 'at'
      subject.locale.should == 'de-at'
    end
  
    it 'should parse not given locale' do
      subject.locale = nil
      subject.locale_major.should == nil
      subject.locale_minor.should == nil
      subject.locale.should == nil
    end
  end
  
  context 'Referer' do
    it 'should get protocol, host, path, and params' do
      subject.referer = 'http://my.domain:1234/test/path?param=1&value=true'
      subject.referer_protocol.should == 'HTTP'
      subject.referer_host.should == 'my.domain:1234'
      subject.referer_path.should == '/test/path'
      subject.referer_params.should == 'param=1&value=true'
    end
    
    it 'should get protocol, host, and path if no params given' do
      subject.referer = 'https://my.domain:1234/test/path'
      subject.referer_protocol.should == 'HTTPS'
      subject.referer_host.should == 'my.domain:1234'
      subject.referer_path.should == '/test/path'
      subject.referer_params.should be_nil
    end    
    
    it 'should get protocol and host if no path and params given' do
      subject.referer = 'http://my.domain:1234'
      subject.referer_protocol.should == 'HTTP'
      subject.referer_host.should == 'my.domain:1234'
      subject.referer_path.should == '/'
      subject.referer_params.should be_nil
    end  
    
    it 'should normalise hosts' do
      subject.referer = 'http://My.Domain/'
      subject.referer_host.should == 'my.domain'
    end  
    
    it 'should accept long referer paths' do
      subject.referer = 'http://my.domain/this/is/a/very/long/path/to/the/page/i/was/referenced/by/and/that/got/tracked/by/gricer/and/should/be/stored/in/a/database/field/to/short/for/storing/the/given/value/as/string/has/only/256/characters/that_should_just_work_fine_and_should_not_create_an_error.html'
      # Emulate SQL db that truncates to long input like MySQL
      if limit = Gricer::Request.columns_hash['referer_path'].limit
        subject.referer_path = subject.referer_path[0, limit]
      end
      limit.should be_nil
        
      subject.referer_path.should == '/this/is/a/very/long/path/to/the/page/i/was/referenced/by/and/that/got/tracked/by/gricer/and/should/be/stored/in/a/database/field/to/short/for/storing/the/given/value/as/string/has/only/256/characters/that_should_just_work_fine_and_should_not_create_an_error.html'
    end
    
  end
  
  context 'Search Engines' do    
    it 'should detect Google as Search Engine' do
      subject.referer = 'http://www.google.com/search?q=test%20this&ie=utf-8&oe=utf-8'
      subject.search_engine.should == 'Google'
      subject.search_query.should == 'test this'
    end
    
    it 'should detect Google (UK) as Search Engine' do
      subject.referer = 'http://www.google.co.uk/search?q=test%20this&ie=utf-8&oe=utf-8'
      subject.search_engine.should == 'Google'
      subject.search_query.should == 'test this'
    end
    
    it 'should detect Google (FR) as Search Engine' do
      subject.referer = 'http://www.google.fr/search?q=test%20this&ie=utf-8&oe=utf-8'
      subject.search_engine.should == 'Google'
      subject.search_query.should == 'test this'
    end
    
    it 'should not detect Google subdomain as Search Engine' do
      subject.referer = 'http://www.google.gmah.net/search?q=test%20this&ie=utf-8&oe=utf-8'
      subject.search_engine.should == nil
      subject.search_query.should == nil
    end
    
    it 'should detect Bing as Search Engine' do
      subject.referer = 'http://www.bing.com/search?q=test+this&go=&qs=n&sk=&form=QBLH&filt=all'
      subject.search_engine.should == 'Bing'
      subject.search_query.should == 'test this'
    end
    
    it 'should detect Yahoo as Search Engine' do
       subject.referer = 'http://de.search.yahoo.com/search;_ylt=AqQWGFQKyJoto6Bia_HjzYsqrK5_;_ylc=X1MDMjE0MjE1Mzc3MARfcgMyBGZyA3lmcC10LTcwOARuX2dwcwMwBG9yaWdpbgNkZS55YWhvby5jb20EcXVlcnkDdGVzdCB0aGlzBHNhbwMx?vc=&vl=&fl=&p=test+this&toggle=1&cop=mss&ei=UTF-8&fr=yfp-t-708'
       subject.search_engine.should == 'Yahoo'
       subject.search_query.should == 'test this'
    end
    
    it 'should detect Altavista (Yahoo) as Search Engine' do
       subject.referer = 'http://us.yhs4.search.yahoo.com/yhs/search;_ylt=A0oG7qWPGiROv2UA_w6l87UF;_ylc=X1MDMjE0MjQ3ODk0OARfcgMyBGZyA2FsdGF2aXN0YQRuX2dwcwMxMARvcmlnaW4Dc3ljBHF1ZXJ5A3Rlc3QgdGhpcwRzYW8DMw--?p=test+this&fr=altavista&fr2=sfp&iscqry='
      subject.search_engine.should == 'Yahoo'
      subject.search_query.should == 'test this'
    end
           
    it 'should detect Baidu as Search Engine' do
      subject.referer = 'http://www.baidu.com/s?wd=test+this&rsv_bp=0&inputT=1928'
      subject.search_engine.should == 'Baidu'
      subject.search_query.should == 'test this'      
    end
    
    it 'should detect Ask as Search Engine' do
      subject.referer = 'http://de.ask.com/web?q=test+this&qsrc=0&o=312&l=dir'
      subject.search_engine.should == 'Ask'
      subject.search_query.should == 'test this'
    end
    
    it 'should detect AOL as Search Engine' do
      subject.referer = 'http://search.aol.com/aol/search?enabled_terms=&s_it=comsearch50&q=test+this'
      subject.search_engine.should == 'AOL'
      subject.search_query.should == 'test this'      
    end
    
    it 'should detect MetaCrawler as Search Engine' do
      subject.referer = 'http://www.metacrawler.com/info.metac.test.c1/search/web?fcoid=417&fcop=topnav&fpid=27&q=test+this'
      subject.search_engine.should == 'MetaCrawler'
      subject.search_query.should == 'test this'      
    end
    
    it 'should detect Dogpile as Search Engine' do
      subject.referer = 'http://www.dogpile.com/dogpile/ws/results/Web/test%20this/1/417/TopNavigation/Relevance/iq=true/zoom=off/_iceUrlFlag=7?_IceUrl=true'
      subject.search_engine.should == 'Dogpile'
      subject.search_query.should == 'test this'      
    end
  end
end