require 'spec_helper'

describe Gricer::Agent do
  context 'agent detection' do    
    [
      #
      # Browsers on Desktop
      #
      
      # ABrowse
      ['Mozilla/5.0 (compatible; U; ABrowse 0.6; Syllable) AppleWebKit/420+ (KHTML, like Gecko)', 'ABrowse', '0.6', '0.6', 'WebKit', '420', 'Syllable', :browser],
      ['Mozilla/5.0 (compatible; ABrowse 0.4; Syllable)', 'ABrowse', '0.4', '0.4', nil, nil, 'Syllable', :browser],
      
      # Acoo Browser
      ['Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Acoo Browser; GTB5; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; Maxthon; InfoPath.1; .NET CLR 3.5.30729; .NET CLR 3.0.30618)', 'Internet Explorer', '7.0', '7.0', 'Trident', '3.1', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; Acoo Browser; GTB6; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; InfoPath.1; .NET CLR 3.5.30729; .NET CLR 3.0.30618)', 'Internet Explorer', '8.0', '8.0', 'Trident', '4.0', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; Acoo Browser; GTB5; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; InfoPath.1; .NET CLR 3.5.30729; .NET CLR 3.0.30618)', 'Internet Explorer', '8.0', '8.0', 'Trident', '4.0', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; GTB6; Acoo Browser; .NET CLR 1.1.4322; .NET CLR 2.0.50727)', 'Internet Explorer', '8.0', '8.0', 'Trident', '4.0', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Acoo Browser; SLCC1; .NET CLR 2.0.50727; Media Center PC 5.0; .NET CLR 3.0.04506)', 'Internet Explorer', '7.0', '7.0', 'Trident', '3.1', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Acoo Browser; GTB5; SLCC1; .NET CLR 2.0.50727; Media Center PC 5.0; .NET CLR 3.0.04506)', 'Internet Explorer', '7.0', '7.0', 'Trident', '3.1', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Acoo Browser; GTB5; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; InfoPath.1; .NET CLR 3.5.30729; .NET CLR 3.0.30618)', 'Internet Explorer', '7.0', '7.0', 'Trident', '3.1', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Acoo Browser; InfoPath.2; .NET CLR 2.0.50727; Alexa Toolbar)', 'Internet Explorer', '7.0', '7.0', 'Trident', '3.1', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Acoo Browser; .NET CLR 2.0.50727; .NET CLR 1.1.4322)', 'Internet Explorer', '7.0', '7.0', 'Trident', '3.1', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Acoo Browser; .NET CLR 1.0.3705; .NET CLR 1.1.4322; .NET CLR 2.0.50727; FDM; .NET CLR 3.0.04506.30; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; InfoPath.2)', 'Internet Explorer', '7.0', '7.0', 'Trident', '3.1', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; Acoo Browser; .NET CLR 1.1.4322; .NET CLR 2.0.50727)', 'Internet Explorer', '6.0', '6.0', 'Trident', '3.0', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; Acoo Browser; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; .NET CLR 2.0.50727)', 'Internet Explorer', '6.0', '6.0', 'Trident', '3.0', 'Windows', :browser],
      # This is probably and IE 8.0 engine reporting as 7.0 and 6.0
      ['Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Trident/4.0; Acoo Browser; GTB5; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; InfoPath.1; .NET CLR 3.5.30729; .NET CLR 3.0.30618)', 'Internet Explorer', '7.0', '7.0', 'Trident', '4.0', 'Windows', :browser],
      
      # AmigaVoyager 
      ['AmigaVoyager/3.2 (AmigaOS/MC680x0)', 'AmigaVoyager', '3.2', '3.2', nil, nil, 'AmigaOS', :browser],
      ['AmigaVoyager/2.95 (compatible; MC680x0; AmigaOS; SV1)', 'AmigaVoyager', '2.95', '2.95', nil, nil, 'AmigaOS', :browser],
      ['AmigaVoyager/2.95 (compatible; MC680x0; AmigaOS)', 'AmigaVoyager', '2.95', '2.95', nil, nil, 'AmigaOS', :browser],
      
      # Arora 
      ['Mozilla/5.0 (Unknown; U; UNIX BSD/SYSV system; C -) AppleWebKit/527+ (KHTML, like Gecko, Safari/419.3) Arora/0.10.2', 'Arora', '0.10.2', '0.10', 'WebKit', '527', 'UNIX', :browser],
      ['Mozilla/5.0 (X11; U; Linux; de-DE) AppleWebKit/527+ (KHTML, like Gecko, Safari/419.3) Arora/0.8.0', 'Arora', '0.8.0', '0.8', 'WebKit', '527', 'Linux', :browser],
      ['Mozilla/5.0 (Windows; U; ; en-NZ) AppleWebKit/527+ (KHTML, like Gecko, Safari/419.3) Arora/0.8.0', 'Arora', '0.8.0', '0.8', 'WebKit', '527', 'Windows', :browser],
      ['Mozilla/5.0 (Windows; U; ; en-NZ) AppleWebKit/527+ (KHTML, like Gecko, Safari/419.3) Arora/0.8.0', 'Arora', '0.8.0', '0.8', 'WebKit', '527', 'Windows', :browser],     
      ['Mozilla/5.0 (X11; U; Linux; ru-RU) AppleWebKit/527+ (KHTML, like Gecko, Safari/419.3) Arora/0.6 (Change: 802 025a17d)', 'Arora', '0.6', '0.6', 'WebKit', '527', 'Linux', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US) AppleWebKit/527+ (KHTML, like Gecko, Safari/419.3) Arora/0.6 (Change: )', 'Arora', '0.6', '0.6', 'WebKit', '527', 'Windows', :browser],
      
      ['Mozilla/5.0 (X11; U; Linux; pt-PT) AppleWebKit/523.15 (KHTML, like Gecko, Safari/419.3) Arora/0.4', 'Arora', '0.4', '0.4', 'WebKit', '523.15', 'Linux', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US) AppleWebKit/527+ (KHTML, like Gecko, Safari/419.3) Arora/0.4 (Change: )', 'Arora', '0.4', '0.4', 'WebKit', '527', 'Windows', :browser],
      
      ['Mozilla/5.0 (X11; U; Linux; en-GB) AppleWebKit/527+ (KHTML, like Gecko, Safari/419.3) Arora/0.3 (Change: 239 52c6958)', 'Arora', '0.3', '0.3', 'WebKit', '527', 'Linux', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN) AppleWebKit/523.15 (KHTML, like Gecko, Safari/419.3) Arora/0.3 (Change: 287 c9dfb30)', 'Arora', '0.3', '0.3', 'WebKit', '523.15', 'Windows', :browser],
      
      ['Mozilla/5.0 (X11; U; Linux; sk-SK) AppleWebKit/523.15 (KHTML, like Gecko, Safari/419.3) Arora/0.2 (Change: 0 )', 'Arora', '0.2', '0.2', 'WebKit', '523.15', 'Linux', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 6.0; de-DE) AppleWebKit/523.15 (KHTML, like Gecko, Safari/419.3) Arora/0.2', 'Arora', '0.2', '0.2', 'WebKit', '523.15', 'Windows', :browser],
      ['Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/533.3 (KHTML, like Gecko) Arora/0.11.0 Safari/533.3', 'Arora', '0.11.0', '0.11', 'WebKit', '533.3', 'Linux', :browser],
      
      # Avant
      ['Avant Browser/1.2.789rel1 (http://www.avantbrowser.com)', 'Avant Browser', '1.2.789', '1.2', nil, nil, 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Avant Browser; Avant Browser; .NET CLR 1.0.3705; .NET CLR 1.1.4322; Media Center PC 4.0; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30)', 'Avant Browser', nil, nil, 'Trident', '3.1', 'Windows', :browser],
      
      # Beonex
      ['Mozilla/5.0 (Windows; U; WinNT; en; rv:1.0.2) Gecko/20030311 Beonex/0.8.2-stable', 'Beonex', '0.8.2', '0.8', 'Gecko', '1.0.2', 'Windows', :browser],
      
      # BonEcho (Firefox 2 preview)
      ['Mozilla/5.0 (X11; U; Linux i686; nl; rv:1.8.1b2) Gecko/20060821 BonEcho/2.0b2 (Debian-1.99+2.0b2+dfsg-1)', 'Firefox', '2.0', '2.0', 'Gecko', '1.8.1', 'Linux', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1b2) Gecko/20060826 BonEcho/2.0b2', 'Firefox', '2.0', '2.0', 'Gecko', '1.8.1', 'Windows', :browser],
      ['Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1b1) Gecko/20060601 BonEcho/2.0b1 (Ubuntu-edgy)', 'Firefox', '2.0', '2.0', 'Gecko', '1.8.1', 'Linux', :browser],
      ['Mozilla/5.0 (X11; U; OpenBSD ppc; en-US; rv:1.8.1.9) Gecko/20070223 BonEcho/2.0.0.9', 'Firefox', '2.0.0.9', '2.0', 'Gecko', '1.8.1.9', 'OpenBSD', :browser],
      ['Mozilla/5.0 (BeOS; U; BeOS BePC; en-US; rv:1.8.1.7) Gecko/20070917 BonEcho/2.0.0.7', 'Firefox', '2.0.0.7', '2.0', 'Gecko', '1.8.1.7', 'BeOS', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1.3) Gecko/20070329 BonEcho/2.0.0.3', 'Firefox', '2.0.0.3', '2.0', 'Gecko', '1.8.1.3', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.3) Gecko/20070322 BonEcho/2.0.0.3', 'Firefox', '2.0.0.3', '2.0', 'Gecko', '1.8.1.3', 'OS X', :browser],
      ['Mozilla/5.0 (BeOS; U; Haiku BePC; en-US; rv:1.8.1.18) Gecko/20081114 BonEcho/2.0.0.18', 'Firefox', '2.0.0.18', '2.0', 'Gecko', '1.8.1.18', 'BeOS', :browser],
      ['Mozilla/5.0 (X11; U; Win95; en-US; rv:1.8.1) Gecko/20061125 BonEcho/2.0', 'Firefox', '2.0', '2.0', 'Gecko', '1.8.1', 'Windows', :browser],
      
      # Browzar
      # Reporting IS 7.0 but using IE 8.0's Trident
      ['Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; .NET4.0C; .NET4.0E; .NET CLR 2.0.50727; .NET CLR 1.1.4322; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; Browzar)', 'Internet Explorer', '7.0', '7.0', 'Trident', '4.0', 'Windows', :browser],
           
      # Camino     
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en; rv:1.9.2.14pre) Gecko/20101212 Camino/2.1a1pre (like Firefox/3.6.14pre)', 'Camino', '2.1', '2.1', 'Gecko', '1.9.2.14', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10.5; it; rv:1.9.0.19) Gecko/2010111021 Camino/2.0.6 (MultiLang) (like Firefox/3.0.19)', 'Camino', '2.0.6', '2.0', 'Gecko', '1.9.0.19', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en; rv:1.8.1.4pre) Gecko/20070511 Camino/1.6pre', 'Camino', '1.6', '1.6', 'Gecko', '1.8.1.4', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en; rv:1.8.1.4pre) Gecko/20070521 Camino/1.6a1pre', 'Camino', '1.6', '1.6', 'Gecko', '1.8.1.4', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; it; rv:1.8.1.21) Gecko/20090327 Camino/1.6.7 (MultiLang) (like Firefox/2.0.0.21pre)', 'Camino', '1.6.7', '1.6', 'Gecko', '1.8.1.21', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en; rv:1.9a4pre) Gecko/20070404 Camino/1.2+', 'Camino', '1.2', '1.2', 'Gecko', '1.9', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.7.8) Gecko/20050427 Camino/0.8.4', 'Camino', '0.8.4', '0.8', 'Gecko', '1.7.8', 'OS X', :browser],
      
      # Charon
      ['Mozilla/4.08 (Charon; Inferno)', 'Charon', nil, nil, nil, nil, 'Inferno', :browser],
      
      # Chimera
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; pl-PL; rv:1.0.1) Gecko/20021111 Chimera/0.6', 'Chimera', '0.6', '0.6', 'Gecko', '1.0.1', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.0.1) Gecko/20030109 Chimera/0.6', 'Chimera', '0.6', '0.6', 'Gecko', '1.0.1', 'OS X', :browser],
      
      # Chrome 
      ['Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/532.5 (KHTML, like Gecko) Chrome/4.0.249.0 Safari/532.5', 'Chrome', '4.0.249.0', '4.0', 'WebKit', '532.5', 'Windows', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US) AppleWebKit/532.9 (KHTML, like Gecko) Chrome/5.0.310.0 Safari/532.9', 'Chrome', '5.0.310.0', '5.0', 'WebKit', '532.9', 'Windows', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/534.7 (KHTML, like Gecko) Chrome/7.0.514.0 Safari/534.7', 'Chrome', '7.0.514.0', '7.0', 'WebKit', '534.7', 'Windows', :browser],
      ['Mozilla/5.0 (Windows NT 5.2) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.792.0 Safari/535.1', 'Chrome', '14.0.792.0', '14.0', 'WebKit', '535.1', 'Windows', :browser],
      ['Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_7) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.790.0 Safari/535.1', 'Chrome', '14.0.790.0', '14.0', 'WebKit', '535.1', 'OS X', :browser],
      ['Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.20 Safari/535.1', 'Chrome', '13.0.782.20', '13.0', 'WebKit', '535.1', 'Linux', :browser],
      ['Mozilla/5.0 (X11; Linux i686) AppleWebKit/534.35 (KHTML, like Gecko) Ubuntu/10.10 Chromium/13.0.764.0 Chrome/13.0.764.0 Safari/534.35', 'Chrome', '13.0.764.0', '13.0', 'WebKit', '534.35', 'Linux', :browser],
      ['Mozilla/5.0 ArchLinux (X11; U; Linux x86_64; en-US) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30', 'Chrome', '12.0.742.100', '12.0', 'WebKit', '534.30', 'Linux', :browser],
      ['Mozilla/5.0 ArchLinux (X11; U; Linux x86_64; en-US) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100', 'Chrome', '12.0.742.100', '12.0', 'WebKit', '534.30', 'Linux', :browser],
      ['Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/534.24 (KHTML, like Gecko) Ubuntu/10.10 Chromium/12.0.703.0 Chrome/12.0.703.0 Safari/534.24', 'Chrome', '12.0.703.0', '12.0', 'WebKit', '534.24', 'Linux', :browser],
      ['Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/534.13 (KHTML, like Gecko) Chrome/9.0.597.0 Safari/534.13', 'Chrome', '9.0.597.0', '9.0', 'WebKit', '534.13', 'Linux', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.13 (KHTML, like Gecko) Chrome/9.0.597.0 Safari/534.13', 'Chrome', '9.0.597.0', '9.0', 'WebKit', '534.13', 'Windows', :browser],
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.13 (KHTML, like Gecko) Chrome/9.0.597.0 Safari/534.13', 'Chrome', '9.0.597.0', '9.0', 'WebKit', '534.13', 'OS X', :browser],
      ['Mozilla/5.0 (X11; U; CrOS i686 0.9.130; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Chrome/8.0.552.344 Safari/534.10', 'Chrome', '8.0.552.344', '8.0', 'WebKit', '534.10', 'CrOS', :browser],
      ['Mozilla/5.0 (X11; U; OpenBSD i386; en-US) AppleWebKit/533.3 (KHTML, like Gecko) Chrome/5.0.359.0 Safari/533.3', 'Chrome', '5.0.359.0', '5.0', 'WebKit', '533.3', 'OpenBSD', :browser],
      ['Mozilla/5.0 (Macintosh; U; Mac OS X 10_6_1; en-US) AppleWebKit/530.5 (KHTML, like Gecko) Chrome/ Safari/530.5', 'Chrome', nil, nil, 'WebKit', '530.5', 'OS X', :browser],
      
      # ChromePlus
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/532.2 (KHTML, like Gecko) ChromePlus/4.0.222.3 Chrome/4.0.222.3 Safari/532.2', 'Chrome', '4.0.222.3', '4.0', 'WebKit', '532.2', 'Windows', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Chrome/8.0.552.215 Safari/534.10 ChromePlus/1.5.1.0alpha3 ChromePlus/1.5.1.0alpha3 ChromePlus/1.5.1.0alpha3', 'Chrome', '8.0.552.215', '8.0', 'WebKit', '534.10', 'Windows', :browser],
      
      # CometBird
      ['Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.0.5) Gecko/2009011615 Firefox/3.0.5 CometBird/3.0.5', 'Firefox', '3.0.5', '3.0', 'Gecko', '1.9.0.5', 'Windows', :browser],
      
      # Comodo_Dragon 
      ['Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/532.5 (KHTML, like Gecko) Comodo_Dragon/4.1.1.11 Chrome/4.1.249.1042 Safari/532.5', 'Chrome', '4.1.249.1042', '4.1', 'WebKit', '532.5', 'Linux', :browser],
      
      # Conkeror 
      ['Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101209 Conkeror/0.9.2 (Debian-0.9.2+git100804-1)', 'Conkeror', '0.9.2', '0.9', 'Gecko', '1.9.1.16', 'Linux', :browser],
      
      # Cyberdog 
      ['Cyberdog/2.0 (Macintosh; PPC)', 'Cyberdog', '2.0', '2.0', nil, nil, 'Classic Macintosh', :browser],
      ['Cyberdog/2.0 (Macintosh; 68k)', 'Cyberdog', '2.0', '2.0', nil, nil, 'Classic Macintosh', :browser],
      
      # Dillo 
      ['Dillo/2.0', 'Dillo', '2.0', '2.0', nil, nil, nil, :browser],
      ['Dillo/0.8.6-i18n-misc', 'Dillo', '0.8.6', '0.8', nil, nil, nil, :browser],
      
      # Elinks
      ['ELinks/0.9.3 (textmode; Linux 2.6.9-kanotix-8 i686; 127x41)', 'ELinks', '0.9.3', '0.9', nil, nil, 'Linux', :browser],
      ['ELinks (0.4pre6; Linux 2.2.19ext3 alpha; 80x25)', 'ELinks', '0.4', '0.4', nil, nil, 'Linux', :browser],
      ['ELinks (0.4.3; NetBSD 3.0.2_PATCH sparc64; 126x14)', 'ELinks', '0.4.3', '0.4', nil, nil, 'NetBSD', :browser],
      ['ELinks/0.12~pre5-1-lite (textmode; Debian; Linux 2.6.31-1+e517a5e9 x86_64; 100x45-2)', 'ELinks', '0.12', '0.12', nil, nil, 'Linux', :browser],
      ['ELinks/0.12pre1.GIT', 'ELinks', '0.12', '0.12', nil, nil, nil, :browser],
      ['ELinks/0.11.4rc1 (textmode; Darwin 8.11.0 Power Macintosh; 169x55-3)', 'ELinks', '0.11.4', '0.11', nil, nil, 'Darwin', :browser],
      ['Elinks (textmode)', 'ELinks', nil, nil, nil, nil, nil, :browser],
      
      # Epiphany (versions since 2.30 use WebKit)
      ['Mozilla/5.0 (X11; U; Linux x86_64; it-it) AppleWebKit/534.26+ (KHTML, like Gecko) Ubuntu/11.04 Epiphany/2.30.6', 'Epiphany', '2.30.6', '2.30', 'WebKit', '534.26', 'Linux', :browser],
      ['Mozilla/5.0 (X11; U; OpenBSD arm; en-us) AppleWebKit/531.2+ (KHTML, like Gecko) Safari/531.2+ Epiphany/2.30.0', 'Epiphany', '2.30.0', '2.30', 'WebKit', '531.2', 'OpenBSD', :browser],
      
      # Epiphany (older versions use Gecko)
      ['Mozilla/5.0 (X11; U; Linux x86_64; en; rv:1.9.0.8) Gecko/20080528 Fedora/2.24.3-4.fc10 Epiphany/2.22 Firefox/3.0', 'Epiphany', '2.22', '2.22', 'Gecko', '1.9.0.8', 'Linux', :browser],
      ['Mozilla/5.0 (X11; U; Linux x86_64; en; rv:1.9.0.7) Gecko/20080528 Epiphany/2.22', 'Epiphany', '2.22', '2.22', 'Gecko', '1.9.0.7', 'Linux', :browser],
      ['Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9b3) Gecko Epiphany/2.20', 'Epiphany', '2.20', '2.20', 'Gecko', '1.9', 'Linux', :browser],
      ['Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051215 Epiphany/1.8.4.1', 'Epiphany', '1.8.4.1', '1.8', 'Gecko', '1.7.12', 'Linux', :browser],
      ['Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030908 Epiphany/0.9.2', 'Epiphany', '0.9.2', '0.9', 'Gecko', '1.4', 'Linux', :browser],
      
      # Epiphany (broken agents are common for it)
      ['Mozilla/5.0 (X11; U; Linux i686; pl-pl) AppleWebKit/525.1+ (KHTML, like Gecko, Safari/525.1+) epiphany-browser', 'Epiphany', nil, nil, 'WebKit', '525.1', 'Linux', :browser],
      ['Mozilla/5.0 (X11; U; Linux i686; en-gb) AppleWebKit/525.1+ (KHTML, like Gecko, Safari/525.1+) epiphany-webkit', 'Epiphany', nil, nil, 'WebKit', '525.1', 'Linux', :browser],
      
      # Firebird
      ['Mozilla/5.0 (Windows; U; Windows NT 6.1; x64; fr; rv:1.9.2.13) Gecko/20101203 Firebird/3.6.13', 'Firefox', '3.6.13', '3.6', 'Gecko', '1.9.2.13', 'Windows', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.6a) Gecko/20031002 Firebird/0.7', 'Firefox', '0.7', '0.7', 'Gecko', '1.6', 'Windows', :browser],
      ['Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.4b) Gecko/20030517 Mozilla Firebird/0.6', 'Firefox', '0.6', '0.6', 'Gecko', '1.4', 'SunOS', :browser],
      
      # Firefox
      ['Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0a2) Gecko/20110613 Firefox/6.0a2', 'Firefox', '6.0', '6.0', 'Gecko', '6.0', 'Windows', :browser],
      ['Mozilla/5.0 (Windows NT 6.1; U; ru; rv:5.0.1.6) Gecko/20110501 Firefox/5.0.1 Firefox/5.0.1', 'Firefox', '5.0.1', '5.0', 'Gecko', '5.0.1.6', 'Windows', :browser],
      ['Mozilla/5.0 (X11; U; Linux amd64; en-US; rv:5.0) Gecko/20110619 Firefox/5.0', 'Firefox', '5.0', '5.0', 'Gecko', '5.0', 'Linux', :browser],
      ['Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20100101 Firefox/5.0 FirePHP/0.5', 'Firefox', '5.0', '5.0', 'Gecko', '5.0', 'Linux', :browser],
      ['Mozilla/5.0 (U; Windows NT 5.1; rv:5.0) Gecko/20100101 Firefox/5.0', 'Firefox', '5.0', '5.0', 'Gecko', '5.0', 'Windows', :browser],
      ['Mozilla/5.0 (X11; Linux x86_64; rv:2.2a1pre) Gecko/20110324 Firefox/4.2a1pre', 'Firefox', '4.2', '4.2', 'Gecko', '2.2', 'Linux', :browser],
      ['Mozilla/5.0 (WindowsCE 6.0; rv:2.0.1) Gecko/20100101 Firefox/4.0.1', 'Firefox', '4.0.1', '4.0', 'Gecko', '2.0.1', 'Windows CE', :browser],
      ['Mozilla/5.0 (X11; Arch Linux i686; rv:2.0) Gecko/20110321 Firefox/4.0', 'Firefox', '4.0', '4.0', 'Gecko', '2.0', 'Linux', :browser],
      ['Mozilla/5.0 (BeOS; U; BeOS BePC; en-US; rv:1.8.1b2) Gecko/20060901 Firefox/2.0b2', 'Firefox', '2.0', '2.0', 'Gecko', '1.8.1', 'BeOS', :browser],
      ['Mozilla/5.0 (X11; U; Gentoo Linux x86_64; pl-PL; rv:1.8.1.7) Gecko/20070914 Firefox/2.0.0.7', 'Firefox', '2.0.0.7', '2.0', 'Gecko', '1.8.1.7', 'Linux', :browser],
      ['Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.8) Gecko/20051130 Firefox/1.5', 'Firefox', '1.5', '1.5', 'Gecko', '1.8', 'SunOS', :browser],
      ['Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081202 Firefox (Debian-2.0.0.19-0etch1)', 'Firefox', nil, nil, 'Gecko', '1.8.1.19', 'Linux', :browser],
      ['Mozilla/5.0 (X11; U; Gentoo Linux x86_64; pl-PL) Gecko Firefox', 'Firefox', nil, nil, 'Gecko', nil, 'Linux', :browser],
      ['Mozilla/5.0 (X11; ; Linux x86_64; rv:1.8.1.6) Gecko/20070802 Firefox', 'Firefox', nil, nil, 'Gecko', '1.8.1.6', 'Linux', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.0.6) Gecko/2009011913 Firefox', 'Firefox', nil, nil, 'Gecko', '1.9.0.6', 'Windows', :browser],
      
      # Flock (versions since 3.0 use WebKit)
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; en-US) AppleWebKit/534.7 (KHTML, like Gecko) Flock/3.5.3.4628 Chrome/7.0.517.450 Safari/534.7', 'Flock', '3.5.3.4628', '3.5', 'WebKit', '534.7', 'OS X', :browser],
      
      # Flock (older versions use Gecko)
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.0.19) Gecko/2010062819 Firefox/3.0.19 Flock/2.6.1', 'Flock', '2.6.1', '2.6', 'Gecko', '1.9.0.19', 'OS X', :browser],
      ['Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8) Gecko/20060102 Flock/0.4.11 Firefox/1.5', 'Flock', '0.4.11', '0.4', 'Gecko', '1.8', 'Linux', :browser],
      
      # Fluid 
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_1; nl-nl) AppleWebKit/532.3+ (KHTML, like Gecko) Fluid/0.9.6 Safari/532.3+', 'Fluid', '0.9.6', '0.9', 'WebKit', '532.3', 'OS X', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.13 (KHTML, like Gecko) Fluid/0.9.4 Safari/525.13', 'Fluid', '0.9.4', '0.9', 'WebKit', '525.13', 'Windows', :browser],
      
      # Galaxy
      ['Galaxy 1.0', 'Galaxy', '1.0', '1.0', nil, nil, nil, :browser],
      ['Galaxy/1.0 [en] (Mac OS X 10.5.6; U; en)', 'Galaxy', '1.0', '1.0', nil, nil, 'OS X', :browser],
      ['Galaxy/1.0 [en] (Mac OS X 10.5.6)', 'Galaxy', '1.0', '1.0', nil, nil, 'OS X', :browser],
      
      # Galeon 
      ['Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.8) Gecko/20090327 Galeon/2.0.7', 'Galeon', '2.0.7', '2.0', 'Gecko', '1.9.0.8', 'Linux', :browser],
      ['Mozilla/5.0 Galeon/1.2.9 (X11; Linux i686; U;) Gecko/20021213 Debian/1.2.9-0.bunk', 'Galeon', '1.2.9', '1.2', 'Gecko', nil, 'Linux', :browser],
      ['Mozilla/5.0 Galeon/1.0.3 (X11; Linux i686; U;) Gecko/0', 'Galeon', '1.0.3', '1.0', 'Gecko', nil, 'Linux', :browser],
      
      # GranParadiso 
      ['Mozilla/5.0(X11;U;Linux(x86_64);en;rv:1.9a8)Gecko/2007100619;GranParadiso/3.1', 'Firefox', '3.1', '3.1', 'Gecko', '1.9', 'Linux', :browser],
      ['Mozilla/5.0 (X11; U; Linux ppc; en-US; rv:1.9a8) Gecko/2007100620 GranParadiso/3.1', 'Firefox', '3.1', '3.1', 'Gecko', '1.9', 'Linux', :browser],
      
      # Hana
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/418.9 (KHTML, like Gecko) Hana/1.1', 'Hana', '1.1', '1.1', 'WebKit', '418.9', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; i386 Mac OS X; en) AppleWebKit/417.9 (KHTML, like Gecko) Hana/1.0', 'Hana', '1.0', '1.0', 'WebKit', '417.9', 'OS X', :browser],
      
      # HotJava
      ['HotJava/1.1.2 FCS', 'HotJava', '1.1.2', '1.1', nil, nil, nil, :browser],
      ['HotJava 1.0.1', 'HotJava', '1.0.1', '1.0', nil, nil, nil, :browser],
      ['HotJava/1.0.1/JRE1.1.x', 'HotJava', '1.0.1', '1.0', nil, nil, nil, :browser],
      
      # IBM WebExplorer 
      ['IBM WebExplorer /v0.94', 'IBM WebExplorer', '0.94', '0.94', nil, nil, 'OS/2', :browser],
      
      # IBrowse 
      ['Mozilla/5.0 (compatible; IBrowse 3.0; AmigaOS4.0)', 'IBrowse', '3.0', '3.0', nil, nil, 'AmigaOS', :browser],
      ['IBrowse/2.4demo (AmigaOS 3.9; 68K)', 'IBrowse', '2.4', '2.4', nil, nil, 'AmigaOS', :browser],
      ['IBrowse/2.4 (AmigaOS 3.9; 68K)', 'IBrowse', '2.4', '2.4', nil, nil, 'AmigaOS', :browser],
      ['Mozilla/4.0 (compatible; IBrowse 2.3; AmigaOS4.0)', 'IBrowse', '2.3', '2.3', nil, nil, 'AmigaOS', :browser],
      ['IBrowse/2.3 (AmigaOS 3.9)', 'IBrowse', '2.3', '2.3', nil, nil, 'AmigaOS', :browser],
      
      # iCab
      ['iCab/4.7 (Macintosh; U; PPC Mac OS X)', 'iCab', '4.7', '4.7', nil, nil, 'OS X', :browser],
      ['Mozilla/5.0 (compatible; iCab 3.0.5; Macintosh; U; PPC Mac OS)', 'iCab', '3.0.5', '3.0', nil, nil, 'OS X', :browser],
      ['iCab/3.0.5 (Macintosh; U; PPC Mac OS X)', 'iCab', '3.0.5', '3.0', nil, nil, 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS; en) iCab 3', 'iCab', '3.0', '3.0', nil, nil, 'OS X', :browser],
      
      # Iceape (like Seamonkey)
      ['Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.13) Gecko/20100916 Iceape/2.0.8', 'Iceape', '2.0.8', '2.0', 'Gecko', '1.9.1.13', 'Linux', :browser], 
      
      # IceCat
      ['Mozilla/5.0 (X11; U; Linux sparc64; es-PY; rv:5.0) Gecko/20100101 IceCat/5.0 (like Firefox/5.0; Debian-6.0.1)', 'Firefox', '5.0', '5.0', 'Gecko', '5.0', 'Linux', :browser], 
      ['Mozilla/5.0 (X11; Linux i686; rv:2.0b8) Gecko/20101227 IceCat/4.0b8', 'Firefox', '4.0', '4.0', 'Gecko', '2.0', 'Linux', :browser], 
      
      # Iceweasel
      ['Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20100101 Firefox/5.0 Iceweasel/5.0', 'Firefox', '5.0', '5.0', 'Gecko', '5.0', 'Linux', :browser], 
      ['Mozilla/5.0 (X11; U; Linux x86_64; fr; rv:1.9.2.13) Gecko/20101203 Iceweasel/3.6.7 (like Firefox/3.6.13)', 'Firefox', '3.6.13', '3.6', 'Gecko', '1.9.2.13', 'Linux', :browser], 
      ['Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1) Gecko/20090704 Iceweasel/3.5 (Debian-3.5-0)', 'Firefox', '3.5', '3.5', 'Gecko', '1.9.1', 'Linux', :browser], 
      ['Mozilla/5.0 (Linux X86; U; Debian SID; it; rv:1.9.0.1) Gecko/2008070208 Debian IceWeasel/3.0.1', 'Firefox', '3.0.1', '3.0', 'Gecko', '1.9.0.1', 'Linux', :browser], 
      ['Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8pre) Gecko/20061001 Firefox/1.5.0.8pre (Iceweasel)', 'Firefox', '1.5.0.8', '1.5', 'Gecko', '1.8.0.8', 'Linux', :browser], 
      ['Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.0.7) Gecko/2009030814 Iceweasel Firefox/3.0.7 (Debian-3.0.7-1)', 'Firefox', '3.0.7', '3.0', 'Gecko', '1.9.0.7', 'Linux', :browser], 
      ['Mozilla/5.0 (Linux) Gecko Iceweasel (Debian) Mnenhy', 'Firefox', nil, nil, 'Gecko', nil, 'Linux', :browser], 
      
      # Internet Explorer 
      ['Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)', 'Internet Explorer', '10.0', '10.0', 'Trident', '6.0', 'Windows', :browser], 
      ['Mozilla/1.22 (compatible; MSIE 10.0; Windows 3.1)', 'Internet Explorer', '10.0', '10.0', 'Trident', '6.0', 'Windows', :browser],
      ['Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 7.1; Trident/5.0)', 'Internet Explorer', '9.0', '9.0', 'Trident', '5.0', 'Windows', :browser],
      ['Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; SLCC2; Media Center PC 6.0; InfoPath.3; MS-RTC LM 8; Zune 4.7)', 'Internet Explorer', '9.0', '9.0', 'Trident', '5.0', 'Windows', :browser],
      ['Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/5.0; chromeframe/11.0.696.57)', 'Internet Explorer', '9.0', '9.0', 'Trident', '5.0', 'Windows', :browser],
      ['Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 5.2; Trident/4.0; Media Center PC 4.0; SLCC1; .NET CLR 3.0.04320)', 'Internet Explorer', '8.0', '8.0', 'Trident', '4.0', 'Windows', :browser],
      ['Mozilla/4.0(compatible; MSIE 7.0b; Windows NT 6.0)', 'Internet Explorer', '7.0', '7.0', 'Trident', '3.1', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 6.1; Windows XP; .NET CLR 1.1.4322; .NET CLR 2.0.50727)', 'Internet Explorer', '6.1', '6.1', 'Trident', '3.0', 'Windows', :browser],
      ['Mozilla/4.0 (Compatible; Windows NT 5.1; MSIE 6.0) (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)', 'Internet Explorer', '6.0', '6.0', 'Trident', '3.0', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 5.5b1; Mac_PowerPC)', 'Internet Explorer', '5.5', '5.5', 'Trident', '2.2', 'OS X', :browser],
      ['Mozilla/4.0 (compatible; MSIE 5.23; Mac_PowerPC)', 'Internet Explorer', '5.23', '5.23', 'Trident', '2.1', 'OS X', :browser],
      ['Mozilla/4.0 PPC (compatible; MSIE 4.01; Windows CE; PPC; 240x320; Sprint:PPC-6700; PPC; 240x320)', 'Internet Explorer', '4.01', '4.01', 'Trident', '1.0', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 4.01; Mac_PowerPC)', 'Internet Explorer', '4.01', '4.01', 'Trident', '1.0', 'OS X', :browser],
      ['Mozilla/1.22 (compatible; MSIE 2.0; Windows 95)', 'Internet Explorer', '2.0', '2.0', nil, nil, 'Windows', :browser],
      ['Mozilla/1.22 (compatible; MSIE 2.0; Windows 3.1)', 'Internet Explorer', '2.0', '2.0', nil, nil, 'Windows', :browser],
      # This is probaly an IE 8.0 engine reporting as IE 6.0
      ['Mozilla/4.0 (compatible; MSIE 6.0b; Windows NT 5.0; YComp 5.0.0.0) (Compatible; ; ; Trident/4.0)', 'Internet Explorer', '6.0', '6.0', 'Trident', '4.0', 'Windows', :browser],
      # This is probaly an IE 8.0 engine reporting as IE 7.0
      ['Mozilla/5.0 (compatible; MSIE 7.0; Windows NT 5.0; Trident/4.0; FBSMTWB; .NET CLR 2.0.34861; .NET CLR 3.0.3746.3218; .NET CLR 3.5.33652; msn OptimizedIE8;ENUS)', 'Internet Explorer', '7.0', '7.0', 'Trident', '4.0', 'Windows', :browser],
      # This is a very strange entry
      ['Mozilla/4.0 (compatible; MSIE 2.0; Windows NT 5.0; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)', 'Internet Explorer', '2.0', '2.0', 'Trident', '4.0', 'Windows', :browser],
      # Probably bots?
      ###['Mozilla/4.0 (X11; MSIE 6.0; i686; .NET CLR 1.1.4322; .NET CLR 2.0.50727; FDM)', 'Internet Explorer', '6.0', '6.0', 'Trident', '3.0', 'Windows', :browser],
      ###['Mozilla/4.0 (MSIE 6.0; Windows NT 5.0)', 'Internet Explorer', '6.0', '6.0', 'Trident', '3.0', 'Windows', :browser],
      ###['Mozilla/4.0 (compatible;MSIE 6.0;Windows 98;Q312461)', 'Internet Explorer', '6.0', '6.0', 'Trident', '3.0', 'Windows', :browser],
      ###['Mozilla/4.0 WebTV/2.6 (compatible; MSIE 4.0)', 'Internet Explorer', '4.0', 'Windows', :browser],
      
      
      # Iron
      ['Mozilla/5.0 (Windows NT 6.1) AppleWebKit/534.30 (KHTML, like Gecko) Iron/12.0.750.0 Chrome/12.0.750.0 Safari/534.30', 'Chrome', '12.0.750.0', '12.0', 'WebKit', '534.30', 'Windows', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US) AppleWebKit/532.0 (KHTML, like Gecko) Iron/3.0.197.0 Safari/532.0', 'Chrome', '3.0.197.0', '3.0', 'WebKit', '532.0', 'Windows', :browser],
      
      # K-Meleon 
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; pl-PL; rv:1.8.1.24pre) Gecko/20100228 K-Meleon/1.5.4', 'K-Meleon', '1.5.4', '1.5', 'Gecko', '1.8.1.24', 'Windows', :browser],
      
      # K-Ninja, K-Meleon derivate
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.4pre) Gecko/20070404 K-Ninja/2.1.3', 'K-Ninja', '2.1.3', '2.1', 'Gecko', '1.8.1.4', 'Windows', :browser],
      
      # KMLite, K-Ninja derivate
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.19) Gecko/20081217 KMLite/1.1.2', 'KMLite', '1.1.2', '1.1', 'Gecko', '1.8.1.19', 'Windows', :browser],
      
      # Kapiko
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.0.1) Gecko/20080722 Firefox/3.0.1 Kapiko/3.0', 'Kapiko', '3.0', '3.0', 'Gecko', '1.9.0.1', 'Windows', :browser],
      
      # Kazehakase
      ['Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.0.7) Gecko Kazehakase/0.5.6', 'Kazehakase', '0.5.6', '0.5', 'Gecko', '1.9.0.7', 'Linux', :browser],
      
      # Konqueror
      ['Mozilla/5.0 (compatible; Konqueror/4.5; FreeBSD) KHTML/4.5.4 (like Gecko)', 'Konqueror', '4.5', '4.5', 'KHTML', '4.5.4', 'FreeBSD', :browser],
      ['Mozilla/5.0 (compatible; Konqueror/4.5; Windows) KHTML/4.5.4 (like Gecko)', 'Konqueror', '4.5', '4.5', 'KHTML', '4.5.4', 'Windows', :browser],
      ['Mozilla/5.0 (compatible; Konqueror/4.2) KHTML/4.2.4 (like Gecko) Fedora/4.2.4-2.fc11', 'Konqueror', '4.2', '4.2', 'KHTML', '4.2.4', nil, :browser],
      ['Mozilla/5.0 (compatible; Konqueror/3.1-rc6; i686 Linux; 20020614)', 'Konqueror', '3.1', '3.1', 'KHTML', '3.1', 'Linux', :browser],
      ['Mozilla/5.0 (compatible; Konqueror/3.0; i686 Linux; 20020510)', 'Konqueror', '3.0', '3.0', 'KHTML', '3.0', 'Linux', :browser],
      ['Mozilla/5.0 (compatible; Konqueror/2.2.2-3; Linux)', 'Konqueror', '2.2.2', '2.2', 'KHTML', '2.2.2', 'Linux', :browser],
      ['Mozilla/5.0 (compatible; Konqueror/2.2.2; Linux 2.4.14-xfs; X11; i686)', 'Konqueror', '2.2.2', '2.2', 'KHTML', '2.2.2', 'Linux', :browser],
      ['Mozilla/5.0 (compatible; Konqueror/2.2.2)', 'Konqueror', '2.2.2', '2.2', 'KHTML', '2.2.2', nil, :browser],
      ['Mozilla/5.0 (compatible; Konqueror/2.2-11; Linux)', 'Konqueror', '2.2', '2.2', 'KHTML', '2.2', 'Linux', :browser],
      ['Mozilla/5.0 (compatible; Konqueror/2.1.2; X11)', 'Konqueror', '2.1.2', '2.1', 'KHTML', '2.1.2', nil, :browser],
      
      # Links
      ['Links (6.9; Unix 6.9-astral sparc; 80x25)', 'Links', '6.9', '6.9', nil, nil, nil, :browser],
      ['Links (2.3pre1; Linux 2.6.35-22-generic i686; 177x51)', 'Links', '2.3', '2.3', nil, nil, 'Linux', :browser],
      ['Links (2.2; OpenBSD 4.8 i386; x)', 'Links', '2.2', '2.2', nil, nil, 'OpenBSD', :browser],
      ['Links (2.2; NetBSD 5.0 i386; 80x25)', 'Links', '2.2', '2.2', nil, nil, 'NetBSD', :browser],
      ['Links (2.1pre33; Darwin 8.11.0 Power Macintosh; 169x55)', 'Links', '2.1', '2.1', nil, nil, 'OS X', :browser],
      ['Links (2.1pre; Linux)', 'Links', '2.1', '2.1', nil, nil, 'Linux', :browser],
      ['Links (2.xpre7; Linux 2.4.18 i586; x)', 'Links', '2.0', '2.0', nil, nil, 'Linux', :browser],
      ['Links 2.0 (http://gossamer-threads.com/scripts/links/)', 'Links', '2.0', '2.0', nil, nil, nil, :browser],
      ['Links (0.98; Unix)', 'Links', '0.98', '0.98', nil, nil, nil, :browser],
      
      # Lynx 
      ['Lynx/2.8.8dev.3 libwww-FM/2.14 SSL-MM/1.4.1', 'Lynx', '2.8.8', '2.8', nil, nil, nil, :browser],
      ['Lynx/2.8.5dev.16', 'Lynx', '2.8.5', '2.8', nil, nil, nil, :browser],
      ['Lynx (textmode)', 'Lynx', nil, nil, nil, nil, nil, :browser],
      
      # Midori
      ['Midori/0.1.10 (X11; Linux i686; U; en-us) WebKit/(531).(2)+', 'Midori', '0.1.10', '0.1', 'WebKit', '531', 'Linux', :browser],
      
      # Minefield (Firefox Alpha)
      ['Mozilla/5.0 (Windows NT 6.1; WOW64; rv:2.0b4pre) Gecko/20100815 Minefield/4.0b4pre', 'Firefox', '4.0', '4.0', 'Gecko', '2.0', 'Windows', :browser],
      ['Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.3a1pre) Gecko/20091022 Minefield/3.7a1pre', 'Firefox', '3.7', '3.7', 'Gecko', '1.9.3', 'Linux', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.3a1pre) Gecko/20091130 Minefield/3.7a1pre GTB6', 'Firefox', '3.7', '3.7', 'Gecko', '1.9.3', 'Windows', :browser],
      
      # Multizilla 1.6 
      ['Mozilla/5.0 (Windows; U; Windows XP) Gecko MultiZilla/1.6.1.0a', 'MultiZilla', '1.6.1.0', '1.6', 'Gecko', nil, 'Windows', :browser],
      
      # NetPositive
      ['Mozilla/3.0 (compatible; NetPositive/2.1.1; BeOS)', 'NetPositive', '2.1.1', '2.1', nil, nil, 'BeOS', :browser],
      
      # NetSurf
      ['NetSurf/1.2 (NetBSD; amd64)', 'NetSurf', '1.2', '1.2', nil, nil, 'NetBSD', :browser],
      
      # Namoroka (Firefox Beta)
      ['Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2a2pre) Gecko/20090825 Namoroka/3.6a2pre', 'Firefox', '3.6', '3.6', 'Gecko', '1.9.2', 'Linux', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9pre) Gecko/20100812 Namoroka/3.6.9pre', 'Firefox', '3.6.9', '3.6', 'Gecko', '1.9.2.9', 'Windows', :browser],
      
      # NCSA Mosaic
      ['NCSA Mosaic/3.0 (Windows 95)', 'Mosaic', '3.0', '3.0', nil, nil, 'Windows', :browser],
      ['NCSA_Mosaic/2.7b4 (X11;AIX 1 000180663000)', 'Mosaic', '2.7', '2.7', nil, nil, 'AIX', :browser],
      ['NCSA_Mosaic/2.6 (X11; SunOS 4.1.3 sun4m)', 'Mosaic', '2.6', '2.6', nil, nil, 'SunOS', :browser],
      ['NCSA_Mosaic/2.0 (Windows 3.1)', 'Mosaic', '2.0', '2.0', nil, nil, 'Windows', :browser],
      ['NCSA Mosaic/1.0 (X11;SunOS 4.1.4 sun4m)', 'Mosaic', '1.0', '1.0', nil, nil, 'SunOS', :browser],
      
      # Netscape
      ['Mozilla/5.0 (Windows; U; Win 9x 4.90; SG; rv:1.9.2.4) Gecko/20101104 Netscape/9.1.0285', 'Netscape Navigator', '9.1.0285', '9.1', 'Gecko', '1.9.2.4', 'Windows', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.8.1.8pre) Gecko/20070928 Firefox/2.0.0.7 Navigator/9.0RC1', 'Netscape Navigator', '9.0', '9.0', 'Gecko', '1.8.1.8', 'Windows', :browser],
      ['Mozilla/5.0 (Windows; U; Win98; en-US; rv:1.4) Gecko Netscape/7.1 (ax)', 'Netscape Navigator', '7.1', '7.1', 'Gecko', '1.4', 'Windows', :browser],
      ### Old Netscapes up to version 4.8
      # Mozilla/4.8 [pl] (Windows NT 5.1; U)
      # Mozilla/4.8 [en] (Windows NT 5.1; U)
      # Mozilla/4.8 [en] (X11; U; SunOS; 5.7 sun4u)
      # Mozilla/4.78 [fr] (X11; U; Linux 2.4.18-14 i686)
      # Mozilla/4.77 [en] (X11; I; IRIX;64 6.5 IP30)
      # Mozilla/4.6 (Macintosh; I; PPC)
      # Mozilla/4.6 [de] (Win98; I)
      # Mozilla/4.08 [en] (WinNT; U ;Nav)
      # Mozilla/4.08 [en] (WinNT; I ;Nav)
      # Mozilla/4.08 [en] (Win98; I ;Nav)
      # Mozilla/4.08 [en] (Win95; I ;Nav)
      # Mozilla/3.04Gold (WinNT; U)
      # Mozilla/3.04 (WinNT; I)
      # Mozilla/3.01Gold (Win95; I)
      # Mozilla/3.0 (Macintosh; I; 68K)
      # Mozilla/2.02Gold (Win95; I)
      # Mozilla/2.02E (Win95; U)
      
      # OmniWeb
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US) AppleWebKit/528.16 (KHTML, like Gecko, Safari/528.16) OmniWeb/v622.8.0.112941', 'OmniWeb', '622.8.0.112941', '622.8', 'WebKit', '528.16', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-US) AppleWebKit/85 (KHTML, like Gecko) OmniWeb/v496', 'OmniWeb', '496.0', '496.0', 'WebKit', '85', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/522+ (KHTML, like Gecko) OmniWeb', 'OmniWeb', nil, nil, 'WebKit', '522', 'OS X', :browser],
      
      # OmniWeb (before WebKit)
      ['Mozilla/4.5 (compatible; OmniWeb/4.2.1-v435.9; Mac_PowerPC)', 'OmniWeb', '4.2.1', '4.2', nil, nil, 'OS X', :browser],
      
      # Opera
      ['Opera/9.80 (X11; Linux i686; U; ru) Presto/2.8.131 Version/11.11', 'Opera', '11.11', '11.11', 'Presto', '2.8.131', 'Linux', :browser],
      ['Mozilla/5.0 (Windows NT 5.1; U; en; rv:1.8.1) Gecko/20061208 Firefox/5.0 Opera 11.11', 'Opera', '11.11', '11.11', 'Presto', '2.8.131', 'Windows', :browser],
      ['Opera/9.80 (Windows NT 6.1; Opera Tablet/15165; U; en) Presto/2.8.149 Version/11.1', 'Opera', '11.1', '11.1', 'Presto', '2.8.149', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 8.0; Linux i686; en) Opera 10.51', 'Opera', '10.51', '10.51', 'Presto', '2.5.24', 'Linux', :browser],
      ['Opera/9.99 (Windows NT 5.1; U; pl) Presto/9.9.9', 'Opera', '9.99', '9.99', 'Presto', '9.9.9', 'Windows', :browser],
      
      ['Opera/9.70 (Linux i686 ; U; ; en) Presto/2.2.1', 'Opera', '9.70', '9.70', 'Presto', '2.2.1', 'Linux', :browser],
      ['Mozilla/5.0 (Linux i686 ; U; en; rv:1.8.1) Gecko/20061208 Firefox/2.0.0 Opera 9.70', 'Opera', '9.70', '9.70', 'Presto', '2.1.1', 'Linux', :browser],
      # Actually this is a Opera Mobile, which is reporting as Desktop - handle a Desktop
      ['HTC_HD2_T8585 Opera/9.70 (Windows NT 5.1; U; de)', 'Opera', '9.70', '9.70', 'Presto', '2.1.1', 'Windows', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9b3) Gecko/2008020514 Opera 9.5', 'Opera', '9.5', '9.5', 'Presto', '2.1', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 6.0; X11; Linux i686; en) Opera 9.27', 'Opera', '9.27', '9.27', 'Presto', '2.0', 'Linux', :browser],
      ['Opera/8.51 (X11; Linux i686; U; en)', 'Opera', '8.51', '8.51', 'Presto', '1.0', 'Linux', :browser],
      ['Mozilla/5.0 (Windows NT 5.1; U; fr) Opera 8.51', 'Opera', '8.51', '8.51', 'Presto', '1.0', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1) Opera 7.52 [en]', 'Opera', '7.52', '7.52', 'Presto', '1.0', 'Windows', :browser],
      ['Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.0.6) Gecko/2009020911 Ubuntu/8.10 (intrepid) Mozilla/4.0 (compatible; MSIE 6.0; MSIE 5.5; Windows NT 5.1) Opera 7.03 [de]', 'Opera', '7.03', '7.03', 'Presto', '1.0', 'Linux', :browser],
      ['Mozilla/4.0 (compatible; MSIE 6.0; MSIE 5.5; Windows 95) Opera 7.03 [de]', 'Opera', '7.03', '7.03', 'Presto', '1.0', 'Windows', :browser],
      ['Mozilla/5.0 (Macintosh; ; Intel Mac OS X; fr; rv:1.8.1.1) Gecko/20061204 Opera', 'Opera', nil, nil, nil, nil, 'OS X', :browser],
      ['Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; en) Opera', 'Opera', nil, nil, nil, nil, 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 6.0; Windows CE) Opera', 'Opera', nil, nil, nil, nil, 'Windows', :browser],
      ['Opera/7.50 (Windows XP; U)', 'Opera', '7.50', '7.50', 'Presto', '1.0', 'Windows', :browser],
      ['Opera/7.50 (Windows ME; U) [en]', 'Opera', '7.50', '7.50', 'Presto', '1.0', 'Windows', :browser],
      ['Opera/7.51 (Windows NT 5.1; U) [en]', 'Opera', '7.51', '7.51', 'Presto', '1.0', 'Windows', :browser],
      ['Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; en) Opera 8.0', 'Opera', '8.0', '8.0', 'Presto', '1.0', 'Windows', :browser],
      ['HTC-ST7377/1.59.502.3 (67150) Opera/9.50 (Windows NT 5.1; U; en) UP.Link/6.3.1.17.0', 'Opera', '9.50', '9.50', 'Presto', '2.1', 'Windows', :browser],
      
      # Palemoon 
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.9.2.8) Gecko/20100817 Firefox/3.6.8 (Palemoon/3.6.8a)', 'Firefox', '3.6.8', '3.6', 'Gecko', '1.9.2.8', 'Windows', :browser],
      
      # Phoenix
      ['Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.3a) Gecko/20021207 Phoenix/0.5', 'Firefox', '0.5', '0.5', 'Gecko', '1.3', 'Linux', :browser],
      ['Mozilla/5.0 (Windows; U; WinNT4.0; en-US; rv:1.2b) Gecko/20021001 Phoenix/0.2', 'Firefox', '0.2', '0.2', 'Gecko', '1.2', 'Windows', :browser],
      
      # Pogo
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.13) Gecko/20080414 Firefox/2.0.0.13 Pogo/2.0.0.13.6866', 'Firefox', '2.0.0.13', '2.0', 'Gecko', '1.8.1.13', 'Windows', :browser],
      
      # Prism 
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.3) Gecko/20100402 Prism/1.0b4', 'Prism', '1.0', '1.0', 'Gecko', '1.9.2.3', 'OS X', :browser],
      ['Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.0.17) Gecko/2010010604 prism/0.8', 'Prism', '0.8', '0.8', 'Gecko', '1.9.0.17', 'Linux', :browser],
      
      # QtWeb Internet Browser
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; pt-BR) AppleWebKit/533.3 (KHTML, like Gecko) QtWeb Internet Browser/3.7 http://www.QtWeb.net', 'QtWeb Internet Browser', '3.7', '3.7', 'WebKit', '533.3', 'Windows', :browser],
      
      # Rekonq
      ['Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ) AppleWebKit/533.3 (KHTML, like Gecko) rekonq Safari/533.3', 'Safari', nil, nil, 'WebKit', '533.3', 'Linux', :browser],
      
      # RockMelt
      ['Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.13 (KHTML, like Gecko) RockMelt/0.9.48.51 Chrome/9.0.597.107 Safari/534.13', 'Chrome', '9.0.597.107', '9.0', 'WebKit', '534.13', 'Windows', :browser],
      
      # Safari
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_7; da-dk) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1', 'Safari', '5.0.5', '5.0', 'WebKit', '533.21.1', 'OS X', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 6.1; cs-CZ) AppleWebKit/533.20.25 (KHTML, like Gecko) Version/5.0.4 Safari/533.20.27', 'Safari', '5.0.4', '5.0', 'WebKit', '533.20.25', 'Windows', :browser],
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_4; th-th) AppleWebKit/533.17.8 (KHTML, like Gecko) Version/5.0.1 Safari/533.17.8', 'Safari', '5.0.1', '5.0', 'WebKit', '533.17.8', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_3; el-gr) AppleWebKit/533.16 (KHTML, like Gecko) Version/5.0 Safari/533.16', 'Safari', '5.0', '5.0', 'WebKit', '533.16', 'OS X', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 5.0; en-en) AppleWebKit/533.16 (KHTML, like Gecko) Version/4.1 Safari/533.16', 'Safari', '4.1', '4.1', 'WebKit', '533.16', 'Windows', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10_4_11; tr) AppleWebKit/528.4+ (KHTML, like Gecko) Version/4.0dp1 Safari/526.11.2', 'Safari', '4.0', '4.0', 'WebKit', '528.4', 'OS X', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; de-DE) AppleWebKit/532+ (KHTML, like Gecko) Version/4.0.4 Safari/531.21.10', 'Safari', '4.0.4', '4.0', 'WebKit', '532', 'Windows', :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN) AppleWebKit/528.16 (KHTML, like Gecko) Version/4.0 Safari/528.16', 'Safari', '4.0', '4.0', 'WebKit', '528.16', 'Windows', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10_5_8; ja-jp) AppleWebKit/530.19.2 (KHTML, like Gecko) Version/3.2.3 Safari/525.28.3', 'Safari', '3.2.3', '3.2', 'WebKit', '530.19.2', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; nl-nl) AppleWebKit/418.8 (KHTML, like Gecko) Safari/419.3', 'Safari', '2.0.4', '2.0', 'WebKit', '418.8', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; sv-se) AppleWebKit/417.9 (KHTML, like Gecko) Safari/417.8_Adobe', 'Safari', '2.0.3', '2.0', 'WebKit', '417.9', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; nl-nl) AppleWebKit/418 (KHTML, like Gecko) Safari/417.9.3', 'Safari', '2.0.3', '2.0', 'WebKit', '418', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; nl-nl) AppleWebKit/417.9 (KHTML, like Gecko) Safari/417.9.2', 'Safari', '2.0.3', '2.0', 'WebKit', '417.9', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; nl-nl) AppleWebKit/416.12 (KHTML, like Gecko) Safari/416.13', 'Safari', '2.0.2', '2.0', 'WebKit', '416.12', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; nl-nl) AppleWebKit/416.11 (KHTML, like Gecko) Safari/416.12', 'Safari', '2.0.2', '2.0', 'WebKit', '416.11', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; nl-nl) AppleWebKit/416.11 (KHTML, like Gecko) Safari/312', 'Safari', '1.3', '1.3', 'WebKit', '416.11', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; fr) AppleWebKit/416.12 (KHTML, like Gecko) Safari/412.5', 'Safari', '2.0.1', '2.0', 'WebKit', '416.12', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/416.11 (KHTML, like Gecko)', 'WebKit Browser', nil, nil, 'WebKit', '416.11', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; ja-jp) AppleWebKit/412.7 (KHTML, like Gecko) Safari/412.5', 'Safari', '2.0.1', '2.0', 'WebKit', '412.7', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/412.7 (KHTML, like Gecko) Safari/412.6', 'Safari', '2.0.1', '2.0', 'WebKit', '412.7', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; de-de) AppleWebKit/412.7 (KHTML, like Gecko) Safari/412.5_Adobe', 'Safari', '2.0.1', '2.0', 'WebKit', '412.7', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS; pl-pl) AppleWebKit/412 (KHTML, like Gecko) Safari/412', 'Safari', '2.0', '2.0', 'WebKit', '412', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; fr) AppleWebKit/412.6 (KHTML, like Gecko) Safari/412.2', 'Safari', '2.0', '2.0', 'WebKit', '412.6', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/412.6.2 (KHTML, like Gecko) Safari/412.2.2', 'Safari', '2.0', '2.0', 'WebKit', '412.6.2', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; sv-se) AppleWebKit/312.8 (KHTML, like Gecko) Safari/312.5', 'Safari', '1.3.2', '1.3', 'WebKit', '312.8', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; it-it) AppleWebKit/312.8 (KHTML, like Gecko) Safari/312.6', 'Safari', '1.3.2', '1.3', 'WebKit', '312.8', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/312.8 (KHTML, like Gecko) Safari/312.3.3', 'Safari', '1.3.1', '1.3', 'WebKit', '312.8', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; sv-se) AppleWebKit/312.5.2 (KHTML, like Gecko) Safari/312.3.3', 'Safari', '1.3.1', '1.3', 'WebKit', '312.5.2', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; sv-se) AppleWebKit/312.5.1 (KHTML, like Gecko) Safari/312.3.1', 'Safari', '1.3.1', '1.3', 'WebKit', '312.5.1', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; fr-fr) AppleWebKit/312.5 (KHTML, like Gecko) Safari/312.3', 'Safari', '1.3.1', '1.3', 'WebKit', '312.5', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/312.5.2 (KHTML, like Gecko) Safari/125', 'Safari', '1.2', '1.2', 'WebKit', '312.5.2', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/312.5.1 (KHTML, like Gecko) Safari/125.9', 'Safari', '1.2.3', '1.2', 'WebKit', '312.5.1', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; it-it) AppleWebKit/312.1 (KHTML, like Gecko) Safari/312', 'Safari', '1.3', '1.3', 'WebKit', '312.1', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; fr-fr) AppleWebKit/312.1 (KHTML, like Gecko) Safari/125', 'Safari', '1.2', '1.2', 'WebKit', '312.1', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; de-de) AppleWebKit/312.1 (KHTML, like Gecko) Safari/312.3.1', 'Safari', '1.3.1', '1.3', 'WebKit', '312.1', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; fr-fr) AppleWebKit/125.5.6 (KHTML, like Gecko) Safari/125.12', 'Safari', '1.2.4', '1.2', 'WebKit', '125.5.6', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; fr-fr) AppleWebKit/125.5.5 (KHTML, like Gecko) Safari/125.11', 'Safari', '1.2.4', '1.2', 'WebKit', '125.5.5', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/125.5.5 (KHTML, like Gecko) Safari/125.5.5', 'Safari', '1.2.2', '1.2', 'WebKit', '125.5.5', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/125.5.5 (KHTML, like Gecko) Safari/125', 'Safari', '1.2', '1.2', 'WebKit', '125.5.5', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; ja-jp) AppleWebKit/125.4 (KHTML, like Gecko) Safari/125.9', 'Safari', '1.2.3', '1.2', 'WebKit', '125.4', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/125.4 (KHTML, like Gecko) Safari/100', 'Safari', nil, nil, 'WebKit', '125.4', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; es-es) AppleWebKit/125.2 (KHTML, like Gecko) Safari/125.8', 'Safari', '1.2.2', '1.2', 'WebKit', '125.2', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-us) AppleWebKit/125.2 (KHTML, like Gecko) Safari/125.7', 'Safari', '1.2.2', '1.2', 'WebKit', '125.2', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/125.2 (KHTML, like Gecko) Safari/85.8', 'Safari', '1.0.3', '1.0', 'WebKit', '125.2', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; it-it) AppleWebKit/124 (KHTML, like Gecko) Safari/125.1', 'Safari', '1.2', '1.2', 'WebKit', '124', 'OS X', :browser],     
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-us) AppleWebKit/124 (KHTML, like Gecko) Safari/125', 'Safari', '1.2', '1.2', 'WebKit', '124', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; fr-fr) AppleWebKit/85.8.5 (KHTML, like Gecko) Safari/85.8.1', 'Safari', '1.0.3', '1.0', 'WebKit', '85.8.5', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-us) AppleWebKit/85.8.2 (KHTML, like Gecko) Safari/85.8', 'Safari', '1.0.3', '1.0', 'WebKit', '85.8.2', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; de-de) AppleWebKit/85.8.5 (KHTML, like Gecko) Safari/85', 'Safari', '1.0', '1.0', 'WebKit', '85.8.5', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; sv-se) AppleWebKit/85.7 (KHTML, like Gecko) Safari/85.5', 'Safari', '1.0', '1.0', 'WebKit', '85.7', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-us) AppleWebKit/85.7 (KHTML, like Gecko) Safari/85.6', 'Safari', '1.0', '1.0', 'WebKit', '85.7', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; de-de) AppleWebKit/85.7 (KHTML, like Gecko) Safari/85.7', 'Safari', '1.0', '1.0', 'WebKit', '85.7', 'OS X', :browser],
      
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; fi-fi) AppleWebKit/420+ (KHTML, like Gecko) Safari/419.3', 'Safari', '2.0.4', '2.0', 'WebKit', '420', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/312.8.1 (KHTML, like Gecko) Safari/312.6', 'Safari', '1.3.2', '1.3', 'WebKit', '312.8.1', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; de-ch) AppleWebKit/85 (KHTML, like Gecko) Safari/85', 'Safari', '1.0', '1.0', 'WebKit', '85', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X; it-IT) AppleWebKit/521.25 (KHTML, like Gecko) Safari/521.24', 'Safari', nil, nil, 'WebKit', '521.25', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en) AppleWebKit/521.32.1 (KHTML, like Gecko) Safari/521.32.1', 'Safari', nil, nil, 'WebKit', '521.32.1', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.6) Gecko/2009011912 Safari/525.27.1', 'Gecko Browser', '1.9.0.6', '1.9', 'Gecko', '1.9.0.6', 'OS X', :browser],
      
      # SeaMonkey
      ['Mozilla/5.0 (Windows NT 5.2; rv:7.0a1) Gecko/20110613 SeaMonkey/2.4a1', 'SeaMonkey', '2.4', '2.4', 'Gecko', '7.0', 'Windows', :browser],
      ['Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0b11) Gecko/20110209 Firefox/ SeaMonkey/2.1b2', 'SeaMonkey', '2.1', '2.1', 'Gecko', '2.0', 'OS X', :browser],
      ['Mozilla/5.0 (Windows NT 5.2; rv:2.0b7pre) Gecko/20100915 Firefox/4.0b7pre SeaMonkey/2.1b1pre', 'SeaMonkey', '2.1', '2.1', 'Gecko', '2.0', 'Windows', :browser],
      ['Firefox/2.0b1 SeaMonkey/1.1.1 Mozilla/5.0 Gecko/20061101', 'SeaMonkey', '1.1.1', '1.1', 'Gecko', nil, nil, :browser],
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.8.1.8) Gecko/20071008 SeaMonkey', 'SeaMonkey', nil, nil, 'Gecko', '1.8.1.8', 'Windows', :browser],
      
      # Shadowfox
      ['Mozilla/5.0 (X11; U; Linux x86_64; us; rv:1.9.1.19) Gecko/20110430 shadowfox/7.0 (like Firefox/7.0', 'Firefox', '7.0', '7.0', 'Gecko', '1.9.1.19', 'Linux', :browser],
      
      # Shiira 
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; ja-jp) AppleWebKit/419 (KHTML, like Gecko) Shiira/1.2.3 Safari/125', 'Shiira', '1.2.3', '1.2', 'WebKit', '419', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-us) AppleWebKit/523.15.1 (KHTML, like Gecko) Shiira Safari/125', 'Shiira', nil, nil, 'WebKit', '523.15.1', 'OS X', :browser],
      
      # Shiretoko 
      ['Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b5pre) Gecko/20090424 Shiretoko/3.5b5pre', 'Firefox', '3.5', '3.5', 'Gecko', '1.9.1', 'Linux', :browser],
      ['Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20100309 Ubuntu/9.04 (jaunty) Shiretoko/3.5.5', 'Firefox', '3.5.5', '3.5', 'Gecko', '1.9.1.5', 'Linux', :browser],
      ['Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20081222 Shiretoko/3.1b3pre', 'Firefox', '3.1', '3.1', 'Gecko', '1.9.1', 'Linux', :browser],
      
      # Stainless 
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_6; en-us) AppleWebKit/528.16 (KHTML, like Gecko) Stainless/0.5.3 Safari/525.20.1', 'Stainless', '0.5.3', '0.5', 'WebKit', '528.16', 'OS X', :browser],
      
      # Sunrise 
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_5; ja-jp) AppleWebKit/525.18 (KHTML, like Gecko) Sunrise/1.7.5 like Safari/5525.20.1', 'Sunrise', '1.7.5', '1.7', 'WebKit', '525.18', 'OS X', :browser],
      ['Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-us) AppleWebKit/125.5.7 (KHTML, like Gecko) SunriseBrowser/0.895', 'Sunrise', '0.895', '0.895', 'WebKit', '125.5.7', 'OS X', :browser],
      
      # Swiftfox
      ['Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1) Gecko/20061024 Firefox/2.0 (Swiftfox)', 'Firefox', '2.0', '2.0', 'Gecko', '1.8.1', 'Linux', :browser],
      ['Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.3) Gecko/20100406 Firefox/3.6.3 (Swiftfox)', 'Firefox', '3.6.3', '3.6', 'Gecko', '1.9.2.3', 'Linux', :browser],
      
      # w3m 
      ['w3m/0.52', 'w3m', '0.5.2', '0.5', nil, nil, nil, :browser],
      ['w3m 0.5.2', 'w3m', '0.5.2', '0.5', nil, nil, nil, :browser],
      ['w3m/0.5.2 (Linux i686; it; Debian-3.0.6-3)', 'w3m', '0.5.2', '0.5', nil, nil, 'Linux', :browser],
      ['w3m/0.5.2 (Debian-3.0.6-3)', 'w3m', '0.5.2', '0.5', nil, nil, 'Linux', :browser],
      ['w3m/0.5.1+cvs-1.968', 'w3m', '0.5.1', '0.5', nil, nil, nil, :browser],
      
      # WorldWideweb (the first internet browser ever!)
      ['WorldWideweb (NEXT)', 'WorldWideweb', nil, nil, nil, nil, 'NeXT OS', :browser],
      
      #
      # Browsers on Consoles
      #
      
      # Nintendo DS
      ['Bunjalloo/0.7.6(Nintendo DS;U;en)', 'Bunjalloo', '0.7.6', '0.7', nil, nil, 'Nintendo DS', :browser],
      
      # PS 3
      ['Mozilla/5.0 (PLAYSTATION 3; 3.55)', 'Playstation 3', '3.55', '3.55', nil, nil, 'Playstation 3', :browser],
      ['Mozilla/5.0 (PLAYSTATION 3; 1.00)', 'Playstation 3', '1.00', '1.00', nil, nil, 'Playstation 3', :browser],
      ['Mozilla/4.0 (PS3 (PlayStation 3); 1.00)', 'Playstation 3', '1.00', '1.00', nil, nil, 'Playstation 3', :browser],
      
      # PSP
      ['PSP (PlayStation Portable); 2.00', 'PlayStation Portable', '2.00', '2.00', nil, nil, 'PlayStation Portable', :browser],
      ['Mozilla/4.0 (PSP (PlayStation Portable); 2.00)', 'PlayStation Portable', '2.00', '2.00', nil, nil, 'PlayStation Portable', :browser],
      
      # Wii
      ['wii libnup/1.0', 'Wii Browser', '1.0', '1.0', nil, nil, 'Nintendo Wii', :browser],
      ['Opera/9.30 (Nintendo Wii; U; ; 2071; Wii Shop Channel/1.0; en)', 'Opera', '9.30', '9.30', 'Presto', '2.0', 'Nintendo Wii', :browser],
      ['Opera/9.30 (Nintendo Wii; U; ; 2047-7;pt-br)', 'Opera', '9.30', '9.30', 'Presto', '2.0', 'Nintendo Wii', :browser],
      ['Opera/9.23 (Nintendo Wii; U; ; 1038-58; Wii Internet Channel/1.0; en)', 'Opera', '9.23', '9.23', 'Presto', '2.0', 'Nintendo Wii', :browser],
      ['Opera/9.00 (Nintendo Wii; U; ; 1038-58; Wii Internet Channel/1.0; en)', 'Opera', '9.00', '9.00', 'Presto', '2.0', 'Nintendo Wii', :browser],
        
      #
      # Browsers on Mobile
      #
      
      # Android Webkit Browser
      ['Mozilla/5.0 (Linux; U; Android 3.0.1; fr-fr; A500 Build/HRI66) AppleWebKit/534.13 (KHTML, like Gecko) Version/4.0 Safari/534.13', 'Mobile Safari', '4.0', '4.0', 'WebKit', '534.13', 'Android', :mobile_browser],
      ['Mozilla/5.0 (Linux; U; Android 3.0; en-us; Xoom Build/HRI39) AppleWebKit/525.10+ (KHTML, like Gecko) Version/3.0.4 Mobile Safari/523.12.2', 'Mobile Safari', '3.0.4', '3.0', 'WebKit', '525.10', 'Android', :mobile_browser],
      ['Mozilla/5.0 (Linux; U; Android 1.5; de-de; Galaxy Build/CUPCAKE) AppleWebKit/528.5+ (KHTML, like Gecko) Version/3.1.2 Mobile Safari/525.20.1', 'Mobile Safari', '3.1.2', '3.1', 'WebKit', '528.5', 'Android', :mobile_browser],
      ['Mozilla/5.0 (Linux; U; Android 2.2; en-ca; GT-P1000M Build/FROYO) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1', 'Mobile Safari', '4.0', '4.0', 'WebKit', '533.1', 'Android', :mobile_browser],
      ['Mozilla/5.0 (Linux; U; Android 3.0.1; en-us; GT-P7100 Build/HRI83) AppleWebkit/534.13 (KHTML, like Gecko) Version/4.0 Safari/534.13', 'Mobile Safari', '4.0', '4.0', 'WebKit', '534.13', 'Android', :mobile_browser],
      ['Mozilla/5.0 (Linux; U; Android 2.3.4; fr-fr; HTC Desire Build/GRJ22) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1', 'Mobile Safari', '4.0', '4.0', 'WebKit', '533.1', 'Android', :mobile_browser],
      ['Mozilla/5.0 (Linux; U; Android 2.3.3; zh-tw; HTC_Pyramid Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1', 'Mobile Safari', '4.0', '4.0', 'WebKit', '533.1', 'Android', :mobile_browser],
      ['Mozilla/5.0 (Linux; U; Android 2.3.3; zh-tw; HTC_Pyramid Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari', 'Mobile Safari', '4.0', '4.0', 'WebKit', '533.1', 'Android', :mobile_browser],
      ['Mozilla/5.0 (Linux; U; Android 3.0.1; fr-fr; A500 Build/HRI66) AppleWebKit/534.13 (KHTML, like Gecko) Version/4.0 Safari/534.13', 'Mobile Safari', '4.0', '4.0', 'WebKit', '534.13', 'Android', :mobile_browser],
      ['Mozilla/5.0 (Linux; U; Android 2.3.3; de-de; HTC Desire Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1', 'Mobile Safari', '4.0', '4.0', 'WebKit', '533.1', 'Android', :mobile_browser],
      ['Mozilla/5.0 (Linux; U; Android 2.2; en-sa; HTC_DesireHD_A9191 Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1', 'Mobile Safari', '4.0', '4.0', 'WebKit', '533.1', 'Android', :mobile_browser],
      ['Mozilla/5.0 (Linux; U; Android 2.2.1; fr-fr; HTC_DesireZ_A7272 Build/FRG83D) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1', 'Mobile Safari', '4.0', '4.0', 'WebKit', '533.1', 'Android', :mobile_browser],
      ['Mozilla/5.0 (Linux; U; Android 2.2.1; en-ca; LG-P505R Build/FRG83) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1', 'Mobile Safari', '4.0', '4.0', 'WebKit', '533.1', 'Android', :mobile_browser],
      ['Mozilla/5.0 (Linux; U; Android 2.2.1; de-de; HTC_Wildfire_A3333 Build/FRG83D) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1', 'Mobile Safari', '4.0', '4.0', 'WebKit', '533.1', 'Android', :mobile_browser],
      ['Mozilla/5.0 (Linux; U; Android 2.0; en-us; Droid Build/ESD20) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17', 'Mobile Safari', '4.0', '4.0', 'WebKit', '530.17', 'Android', :mobile_browser],
      ['Mozilla/5.0 (Linux; U; Android 1.6; ar-us; SonyEricssonX10i Build/R2BA026) AppleWebKit/528.5+ (KHTML, like Gecko) Version/3.1.2 Mobile Safari/525.20.1', 'Mobile Safari', '3.1.2', '3.1', 'WebKit', '528.5', 'Android', :mobile_browser],
      ['Mozilla/5.0 (Android 2.2; Windows; U; Windows NT 6.1; en-US) AppleWebKit/533.19.4 (KHTML, like Gecko) Version/5.0.3 Safari/533.19.4', 'Mobile Safari', '5.0.3', '5.0', 'WebKit', '533.19.4', 'Android', :mobile_browser],
      
      # BlackBerry
      ['Mozilla/5.0 (BlackBerry; U; BlackBerry 9850; en-US) AppleWebKit/534.11+ (KHTML, like Gecko) Version/7.0.0.115 Mobile Safari/534.11+', 'BlackBerry Browser', '7.0.0.115', '7.0', 'WebKit', '534.11', 'BlackBerry', :mobile_browser],
      ['Mozilla/5.0 (BlackBerry; U; BlackBerry 9800; zh-TW) AppleWebKit/534.8+ (KHTML, like Gecko) Version/6.0.0.448 Mobile Safari/534.8+', 'BlackBerry Browser', '6.0.0.448', '6.0', 'WebKit', '534.8', 'BlackBerry', :mobile_browser],
      ['Mozilla/5.0 (BlackBerry; U; BlackBerry 9700; pt) AppleWebKit/534.8+ (KHTML, like Gecko) Version/6.0.0.546 Mobile Safari/534.8+', 'BlackBerry Browser', '6.0.0.546', '6.0', 'WebKit', '534.8', 'BlackBerry', :mobile_browser],
      ['BlackBerry9800/5.0.0.862 Profile/MIDP-2.1 Configuration/CLDC-1.1 VendorID/331 UNTRUSTED/1.0 3gpp-gba', 'BlackBerry Browser', '5.0.0.862', '5.0', nil, nil, 'BlackBerry', :mobile_browser],
      ['BlackBerry9700/5.0.0.862 Profile/MIDP-2.1 Configuration/CLDC-1.1 VendorID/331 UNTRUSTED/1.0 3gpp-gba', 'BlackBerry Browser', '5.0.0.862', '5.0', nil, nil, 'BlackBerry', :mobile_browser],
      ['BlackBerry7100i/4.1.0 Profile/MIDP-2.0 Configuration/CLDC-1.1 VendorID/103', 'BlackBerry Browser', '4.1.0', '4.1', nil, nil, 'BlackBerry', :mobile_browser],
      
      # Blazer (Palm Browser)
      ['Mozilla/4.0 (compatible; MSIE 6.0; Windows 95; PalmSource; Blazer 3.0) 16; 160x160', 'Blazer', '3.0', '3.0', nil, nil, 'Palm OS', :mobile_browser],
      ['Mozilla/4.0 (compatible; MSIE 6.0; Windows 98; PalmSource/hspr-H102; Blazer/4.0) 16;320x320', 'Blazer', '4.0', '4.0', nil, nil, 'Palm OS', :mobile_browser],
      
      # Bolt 
      ['Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; BOLT/2.340) AppleWebKit/530+ (KHTML, like Gecko) Version/4.0 Safari/530.17 UNTRUSTED/1.0 3gpp-gba', 'Bolt', '2.340', '2.340', 'WebKit', '530', 'J2ME', :mobile_browser],
      
      # Browser for S60 
      ['SamsungI8910/SymbianOS/9.1 Series60/3.0', 'Browser for S60', '3.0', '3.0', nil, nil, 'Symbian OS', :mobile_browser],
      ['NokiaN97i/SymbianOS/9.1 Series60/3.0', 'Browser for S60', '3.0', '3.0', nil, nil, 'Symbian OS', :mobile_browser],
      ['NokiaE52-1/SymbianOS/9.1 Series60/3.0 3gpp-gba', 'Browser for S60', '3.0', '3.0', nil, nil, 'Symbian OS', :mobile_browser],
      ['NokiaE5-00/SymbianOS/9.1 Series60/3.0 3gpp-gba', 'Browser for S60', '3.0', '3.0', nil, nil, 'Symbian OS', :mobile_browser],
      ['NokiaC7-00/SymbianOS/9.1 Series60/3.0 3gpp-gba', 'Browser for S60', '3.0', '3.0', nil, nil, 'Symbian OS', :mobile_browser],
      ['Mozilla/5.0 (SymbianOS/9.4; Series60/5.0 NokiaC6-00/20.0.042; Profile/MIDP-2.1 Configuration/CLDC-1.1; zh-hk) AppleWebKit/525 (KHTML, like Gecko) BrowserNG/7.2.6.9 3gpp-gba', 'Browser for S60', '5.0', '5.0', 'WebKit', '525', 'Symbian OS', :mobile_browser],
      ['Mozilla/5.0 (SymbianOS/9.3; Series60/3.2 NokiaE52-1/052.003; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/525 (KHTML, like Gecko) Version/3.0 BrowserNG/7.2.6.2 3gpp-gba', 'Browser for S60', '3.2', '3.2', 'WebKit', '525', 'Symbian OS', :mobile_browser],
      ['NokiaC6-00/10.0.021 (SymbianOS/9.4; Series60/5.0 Mozilla/5.0; Profile/MIDP-2.1 Configuration/CLDC-1.1) AppleWebkit/525 (KHTML, like Gecko) BrowserNG/7.2.6 UNTRUSTED/1.0 3gpp-gba', 'Browser for S60', '5.0', '5.0', 'WebKit', '525', 'Symbian OS', :mobile_browser],
      ['NokiaN97/21.1.107 (SymbianOS/9.4; Series60/5.0 Mozilla/5.0; Profile/MIDP-2.1 Configuration/CLDC-1.1) AppleWebkit/525 (KHTML, like Gecko) BrowserNG/7.1.4', 'Browser for S60', '5.0', '5.0', 'WebKit', '525', 'Symbian OS', :mobile_browser],
      ['NokiaC5-00/061.005 (SymbianOS/9.3; U; Series60/3.2 Mozilla/5.0; Profile/MIDP-2.1 Configuration/CLDC-1.1) AppleWebKit/525 (KHTML, like Gecko) Version/3.0 Safari/525 3gpp-gba', 'Browser for S60', '3.2', '3.2', 'WebKit', '525', 'Symbian OS', :mobile_browser],
      ['Nokia5250/11.0.008 (SymbianOS/9.4; U; Series60/5.0 Mozilla/5.0; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/525 (KHTML, like Gecko) Safari/525 3gpp-gba', 'Browser for S60', '5.0', '5.0', 'WebKit', '525', 'Symbian OS', :mobile_browser],
      ['Nokia5250/10.0.011 (SymbianOS/9.4; U; Series60/5.0 Mozilla/5.0; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/525 (KHTML, like Gecko) Safari/525 3gpp-gba', 'Browser for S60', '5.0', '5.0', 'WebKit', '525', 'Symbian OS', :mobile_browser],
      
      # Doris (Symbian)
      ['Doris/1.15 [en] (Symbian)', 'Doris', '1.15', '1.15', nil, nil, 'Symbian OS', :mobile_browser],
      
      # Dorothy
      ['Mozilla/5.0 (Windows; U; Windows CE; Mobile; like iPhone; ko-kr) AppleWebKit/533.3 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.3 Dorothy', 'Dorothy', '4.0', '4.0', 'WebKit', '533.3', 'Windows CE', :mobile_browser],
      ['Mozilla/5.0 (Windows; U; Windows CE; Mobile; like Android; ko-kr) AppleWebKit/533.3 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.3 Dorothy', 'Dorothy', '4.0', '4.0', 'WebKit', '533.3', 'Windows CE', :mobile_browser],
      ['Mozilla/5.0 (Windows; U; Mobile; Dorothy Browser; en-US) AppleWebKit/533.3 (KHTML, like Gecko) Version/3.1.2 Mobile Safari/533.3', 'Dorothy', '3.1.2', '3.1', 'WebKit', '533.3', 'Windows CE', :mobile_browser],
      ['Mozilla/5.0 (Windows; U; Dorothy Browser; ko-kr) AppleWebKit/533.3 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.3', 'Dorothy', '4.0', '4.0', 'WebKit', '533.3', 'Windows CE', :mobile_browser],
      
      # EudoraWeb
      ['Mozilla/1.22 (compatible; MSIE 5.01; PalmOS 3.0) EudoraWeb 2.1', 'EudoraWeb', '2.1', '2.1', nil, nil, 'PalmOS', :mobile_browser],
      
      # Fennec
      ['Mozilla/5.0 (Maemo; Linux armv7l; rv:5.0) Gecko/20110615 Firefox/5.0 Fennec/5.0', 'Fennec', '5.0', '5.0', 'Gecko', '5.0', 'Maemo', :mobile_browser],
      ['Mozilla/5.0 (Android; WOW64; Linux armv7l;rv:5.0) Gecko/20110603 Firefox/5.0 Fennec/5.0', 'Fennec', '5.0', '5.0', 'Gecko', '5.0', 'Android', :mobile_browser],
      ['Mozilla/5.0 (Windows NT 6.1; WOW64; rv:2.0b8) Gecko/20101221 Firefox/4.0b8 Fennec/4.0b3', 'Fennec', '4.0', '4.0', 'Gecko', '2.0', 'Windows', :mobile_browser],
      ['Mozilla/5.0 (X11; Linux armv7l; rv:2.0b4pre) Gecko/20100812 Firefox/4.0b4pre Fennec/2.0a1pre', 'Fennec', '2.0', '2.0', 'Gecko', '2.0', 'Linux', :mobile_browser],
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.2a1pre) Gecko/20090626 Fennec/1.0b2', 'Fennec', '1.0', '1.0', 'Gecko', '1.9.2', 'OS X', :mobile_browser],
      ['Mozilla/5.0 (Windows; U; Windows CE 5.2; en-US; rv:1.9.2a1pre) Gecko/20090210 Fennec/0.11', 'Fennec', '0.11', '0.11', 'Gecko', '1.9.2', 'Windows CE', :mobile_browser],
      
      # Go Browser
      ['NokiaE66/GoBrowser/2.0.297', 'GoBrowser', '2.0.297', '2.0', nil, nil, nil, :mobile_browser],
      ['NokiaX6/GoBrowser', 'GoBrowser', nil, nil, nil, nil, nil, :mobile_browser],
      ['Mozilla/5.0 (Android 2.2; zh-cn; HTC Desire)/GoBrowser', 'GoBrowser', nil, nil, nil, nil, 'Android', :mobile_browser],
      
      # IE Mobile
      ['Mozilla/5.0 (compatible; MSIE 9.0; Windows Phone OS 7.5; Trident/5.0; IEMobile/9.0)', 'IE Mobile', '9.0', '9.0', 'Trident', '5.0', 'Windows Phone', :mobile_browser],
      ['HTC_Touch_3G Mozilla/4.0 (compatible; MSIE 6.0; Windows CE; IEMobile 7.11)', 'IE Mobile', '7.11', '7.11', 'Trident', '3.1', 'Windows CE', :mobile_browser],
      ['Mozilla/4.0 (compatible; MSIE 7.0; Windows Phone OS 7.0; Trident/3.1; IEMobile/7.0; Nokia;N70)', 'IE Mobile', '7.0', '7.0', 'Trident', '3.1', 'Windows Phone', :mobile_browser],
      ['Mozilla/4.0 (compatible; MSIE 6.0; Windows CE; IEMobile 6.12; Microsoft ZuneHD 4.3)', 'IE Mobile', '6.12', '6.12', 'Trident', '3.0', 'Windows CE', :mobile_browser],
      ['Mozilla/4.0 (compatible; MSIE 4.01; Windows CE; PPC; MDA Pro/1.0 Profile/MIDP-2.0 Configuration/CLDC-1.1)', 'IE Mobile', '4.01', '4.01', 'Trident', '1.0', 'Windows CE', :mobile_browser],
      
      # IMode mobile browser
      ['portalmmm/2.0 N410i(c20;TB) ', 'IMode mobile browser', '2.0', '2.0', nil, nil, nil, :mobile_browser],
      
      # LG MIDP browsers
      ['LG-LX550 AU-MIC-LX550/2.0 MMP/2.0 Profile/MIDP-2.0 Configuration/CLDC-1.1', 'MIDP Browser', '2.0', '2.0', nil, nil, 'J2ME', :mobile_browser],
      ['LG-GC900/V10a Obigo/WAP2.0 Profile/MIDP-2.1 Configuration/CLDC-1.1', 'MIDP Browser', '2.1', '2.1', nil, nil, 'J2ME', :mobile_browser],
      
      # Maemo Browser
      ['Mozilla/5.0 (X11; U; Linux armv7l; ru-RU; rv:1.9.2.3pre) Gecko/20100723 Firefox/3.5 Maemo Browser 1.7.4.8 RX-51 N900', 'Maemo Browser', '1.7.4.8', '1.7', 'Gecko', '1.9.2.3', 'Maemo', :mobile_browser],
      
      # Motorola Internet Browser (MIB)
      ['MOT-L7/NA.ACR_RB MIB/2.2.1 Profile/MIDP-2.0 Configuration/CLDC-1.1', 'Motorola Internet Browser', '2.2.1', '2.2', nil, nil, 'J2ME', :mobile_browser],
      ['MOT-V300/0B.09.19R MIB/2.2 Profile/MIDP-2.0 Configuration/CLDC-1.0', 'Motorola Internet Browser', '2.2', '2.2', nil, nil, 'J2ME', :mobile_browser],
      ['MOT-L7v/08.B7.5DR MIB/2.2.1 Profile/MIDP-2.0 Configuration/CLDC-1.1 UP.Link/6.3.0.0.0', 'Motorola Internet Browser', '2.2.1', '2.2', nil, nil, 'J2ME', :mobile_browser],
      ['MOT-V9mm/00.62 UP.Browser/6.2.3.4.c.1.123 (GUI) MMP/2.0', 'UP Browser', '6.2.3.4', '6.2', nil, nil, 'J2ME', :mobile_browser],
      ['MOTORIZR-Z8/46.00.00 Mozilla/4.0 (compatible; MSIE 6.0; Symbian OS; 356) Opera 8.65 [it] UP.Link/6.3.0.0.0', 'Opera Mobile', '8.65', '8.65', 'Presto', '2.1', 'Symbian OS', :mobile_browser],
      ['MOT-V177/0.1.75 UP.Browser/6.2.3.9.c.12 (GUI) MMP/2.0 UP.Link/6.3.1.13.0', 'UP Browser', '6.2.3.9', '6.2', nil, nil, 'J2ME', :mobile_browser],
      
      # Mini Mozilla (Minimo)
      ['Mozilla/5.0 (X11; U; Linux arm7tdmi; rv:1.8.1.11) Gecko/20071130 Minimo/0.025', 'Minimo', '0.025', '0.025', 'Gecko', '1.8.1.11', 'Linux', :mobile_browser],
      ['Mozilla/5.0 (Windows; Windows; U; Windows NT 5.1; Windows CE 5.2; rv:1.8.1.4pre) Gecko/20070327 Minimo/0.020', 'Minimo', '0.020', '0.020', 'Gecko', '1.8.1.4', 'Windows CE', :mobile_browser],
      ['Mozilla/5.0 (Windows; U; Windows CE 5.2; rv:1.8.1.4pre) Gecko/20070327 Minimo/0.020', 'Minimo', '0.020', '0.020', 'Gecko', '1.8.1.4', 'Windows CE', :mobile_browser],
      ['Mozilla/5.0 (X11; U; OpenBSD macppc; rv:1.8.1) Gecko/20070222 Minimo/0.016', 'Minimo', '0.016', '0.016', 'Gecko', '1.8.1', 'OpenBSD', :mobile_browser],
                    
      # NetFront
      ['SAMSUNG-C5212/C5212XDIK1 NetFront/3.4 Profile/MIDP-2.0 Configuration/CLDC-1.1', 'NetFront', '3.4', '3.4', nil, nil, nil, :mobile_browser],
      ['MozillaMozilla/4.0 (compatible; Linux 2.6.22) NetFront/3.4 Kindle/2.5 (screen 824x1200;rotate)', 'NetFront', '3.4', '3.4', nil, nil, 'Kindle', :mobile_browser],
      ['Mozilla/4.0 (compatible; Linux 2.6.22) NetFront/3.4 Kindle/2.5 (screen 824x1200;rotate)', 'NetFront', '3.4', '3.4', nil, nil, 'Kindle', :mobile_browser],
      ['SonyEricssonK800c/R8BF Browser/NetFront/3.3 Profile/MIDP-2.0 Configuration/CLDC-1.1', 'NetFront', '3.3', '3.3', nil, nil, nil, :mobile_browser],
      ['Mozilla/4.0 (compatible; Linux 2.6.10) NetFront/3.3 Kindle/1.0 (screen 600x800)', 'NetFront', '3.3', '3.3', nil, nil, 'Kindle', :mobile_browser],
      ['Mozilla/4.0 (PDA; PalmOS/sony/model prmr/Revision:1.1.54 (en)) NetFront/3.0', 'NetFront', '3.0', '3.0', nil, nil, 'PalmOS', :mobile_browser],
      
      # Nokia browsers
      ['Nokia3230/2.0 (5.0614.0) SymbianOS/7.0s Series60/2.1 Profile/MIDP-2.0 Configuration/CLDC-1.0', 'Browser for S60', '2.1', '2.1', nil, nil, 'Symbian OS', :mobile_browser],
      ['Mozilla/5.0 (SymbianOS/9.2; U; Series60/3.1 Nokia6120c/3.70; Profile/MIDP-2.0 Configuration/CLDC-1.1) AppleWebKit/413 (KHTML, like Gecko) Safari/413', 'Browser for S60', '3.1', '3.1', 'WebKit', '413', 'Symbian OS', :mobile_browser],
      ['Nokia6230/2.0 (04.44) Profile/MIDP-2.0 Configuration/CLDC-1.1', 'MIDP Browser', '2.0', '2.0', nil, nil, 'J2ME', :mobile_browser],
      ['Mozilla/4.1 (compatible; MSIE 5.0; Symbian OS; Nokia 6600;452) Opera 6.20 [en-US]', 'Opera Mobile', '6.20', '6.20', nil, nil, 'Symbian OS', :mobile_browser],
      ['Nokia6630/1.0 (2.39.15) SymbianOS/8.0 Series60/2.6 Profile/MIDP-2.0 Configuration/CLDC-1.1', 'Browser for S60', '2.6', '2.6', nil, nil, 'Symbian OS', :mobile_browser],
      ['Mozilla/4.0 (compatible; MSIE 5.0; Series80/2.0 Nokia9500/4.51 Profile/MIDP-2.0 Configuration/CLDC-1.1)', 'Browser for S80', '2.0', '2.0', nil, nil, 'Symbian OS', :mobile_browser],
      ['Mozilla/5.0 (Symbian/3; Series60/5.2 NokiaC6-01/011.010; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/525 (KHTML, like Gecko) Version/3.0 BrowserNG/7.2.7.2 3gpp-gba', 'Browser for S60', '5.2', '5.2', 'WebKit', '525', 'Symbian OS', :mobile_browser],
      ['Mozilla/5.0 (Symbian/3; Series60/5.2 NokiaC7-00/012.003; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/525 (KHTML, like Gecko) Version/3.0 BrowserNG/7.2.7.3 3gpp-gba', 'Browser for S60', '5.2', '5.2', 'WebKit', '525', 'Symbian OS', :mobile_browser],
      ['Mozilla/5.0 (SymbianOS/9.1; U; en-us) AppleWebKit/413 (KHTML, like Gecko) Safari/413 es50', 'Browser for S60', nil, nil, 'WebKit', '413', 'Symbian OS', :mobile_browser],
      ['Mozilla/5.0 (Symbian/3; Series60/5.2 NokiaE6-00/021.002; Profile/MIDP-2.1 Configuration/CLDC-1.1) AppleWebKit/533.4 (KHTML, like Gecko) NokiaBrowser/7.3.1.16 Mobile Safari/533.4 3gpp-gba', 'Browser for S60', '5.2', '5.2', 'WebKit', '533.4', 'Symbian OS', :mobile_browser],
      ['Mozilla/5.0 (SymbianOS/9.1; U; en-us) AppleWebKit/413 (KHTML, like Gecko) Safari/413 es65', 'Browser for S60', nil, nil, 'WebKit', '413', 'Symbian OS', :mobile_browser],
      ['Mozilla/5.0 (Symbian/3; Series60/5.2 NokiaE7-00/010.016; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/525 (KHTML, like Gecko) Version/3.0 BrowserNG/7.2.7.3 3gpp-gba', 'Browser for S60', '5.2', '5.2', 'WebKit', '525', 'Symbian OS', :mobile_browser],
      ['Mozilla/5.0 (SymbianOS/9.2; U; Series60/3.1 NokiaE90-1/07.24.0.3; Profile/MIDP-2.0 Configuration/CLDC-1.1 ) AppleWebKit/413 (KHTML, like Gecko) Safari/413 UP.Link/6.2.3.18.0', 'Browser for S60', '3.1', '3.1', 'WebKit', '413', 'Symbian OS', :mobile_browser],
      ['NokiaN70-1/5.0609.2.0.1 Series60/2.8 Profile/MIDP-2.0 Configuration/CLDC-1.1 UP.Link/6.3.1.13.0', 'Browser for S60', '2.8', '2.8', nil, nil, 'Symbian OS', :mobile_browser],
      ['Mozilla/5.0 (SymbianOS/9.1; U; en-us) AppleWebKit/413 (KHTML, like Gecko) Safari/413', 'Browser for S60', nil, nil, 'WebKit', '413', 'Symbian OS', :mobile_browser],
      ['NokiaN73-1/3.0649.0.0.1 Series60/3.0 Profile/MIDP2.0 Configuration/CLDC-1.1', 'Browser for S60', '3.0', '3.0', nil, nil, 'Symbian OS', :mobile_browser],
      ['Mozilla/5.0 (Symbian/3; Series60/5.2 NokiaN8-00/014.002; Profile/MIDP-2.1 Configuration/CLDC-1.1; en-us) AppleWebKit/525 (KHTML, like Gecko) Version/3.0 BrowserNG/7.2.6.4 3gpp-gba', 'Browser for S60', '5.2', '5.2', 'WebKit', '525', 'Symbian OS', :mobile_browser],
      ['Mozilla/5.0 (SymbianOS/9.1; U; en-us) AppleWebKit/413 (KHTML, like Gecko) Safari/413', 'Browser for S60', nil, nil, 'WebKit', '413', 'Symbian OS', :mobile_browser],
      ['Mozilla/5.0 (SymbianOS/9.1; U; de) AppleWebKit/413 (KHTML, like Gecko) Safari/413', 'Browser for S60', nil, nil, 'WebKit', '413', 'Symbian OS', :mobile_browser],
      ['Mozilla/5.0 (SymbianOS/9.2; U; Series60/3.1 NokiaN95/10.0.018; Profile/MIDP-2.0 Configuration/CLDC-1.1) AppleWebKit/413 (KHTML, like Gecko) Safari/413 UP.Link/6.3.0.0.0', 'Browser for S60', '3.1', '3.1', 'WebKit', '413', 'Symbian OS', :mobile_browser],
      ['Mozilla/5.0 (SymbianOS/9.4; Series60/5.0 NokiaN97-1/10.0.012; Profile/MIDP-2.1 Configuration/CLDC-1.1; en-us) AppleWebKit/525 (KHTML, like Gecko) WicKed/7.1.12344', 'Browser for S60', '5.0', '5.0', 'WebKit', '525', 'Symbian OS', :mobile_browser],
      ['Mozilla/5.0 (Symbian/3; Series60/5.2 NokiaX7-00/021.004; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/533.4 (KHTML, like Gecko) NokiaBrowser/7.3.1.21 Mobile Safari/533.4 3gpp-gba', 'Browser for S60', '5.2', '5.2', 'WebKit', '533.4', 'Symbian OS', :mobile_browser],
      
      # Opera Mini
      ['Opera/9.80 (J2ME/MIDP; Opera Mini/5.0 (Windows; U; Windows NT 5.1; en) AppleWebKit/886; U; en) Presto/2.4.15', 'Opera Mini', '5.0', '5.0', 'Presto', '2.4.15', 'J2ME', :mobile_browser],
      ['Opera/9.80 (J2ME/MIDP; Opera Mini/9.80 (J2ME/22.478; U; en) Presto/2.5.25 Version/10.54', 'Opera Mini', '9.80', '9.80', 'Presto', '2.5.25', 'J2ME', :mobile_browser],
      ['Opera/9.80 (J2ME/MIDP; Opera Mini/9 (Compatible; MSIE:9.0; iPhone; BlackBerry9700; AppleWebKit/24.746; U; en) Presto/2.5.25 Version/10.54', 'Opera Mini', '10.54', '10.54', 'Presto', '2.5.25', 'BlackBerry', :mobile_browser],
      ['Opera/9.80 (Android;Opera Mini/6.0.24212/24.746 U;en) Presto/2.5.25 Version/10.5454', 'Opera Mini', '6.0.24212', '6.0', 'Presto', '2.5.25', 'Android', :mobile_browser],
      ['Opera/9.80 (Series 60; Opera Mini/6.0.24095/24.741; U; zh) Presto/2.5.25 Version/10.54', 'Opera Mini', '6.0.24095', '6.0', 'Presto', '2.5.25', 'Symbian OS', :mobile_browser],
      ['Opera/9.80 (Android; Opera Mini/5.1.22460/22.414; U; de) Presto/2.5.25 Version/10.54', 'Opera Mini', '5.1.22460', '5.1', 'Presto', '2.5.25', 'Android', :mobile_browser],
      ['Opera/9.80 (BlackBerry; Opera Mini/5.1.22303/22.387; U; en) Presto/2.5.25 Version/10.54', 'Opera Mini', '5.1.22303', '5.1', 'Presto', '2.5.25', 'BlackBerry', :mobile_browser],
      ['Opera/9.80 (J2ME/MIDP; Opera Mini/5.1.22296; BlackBerry9800; U; AppleWebKit/23.370; U; en) Presto/2.5.25 Version/10.54', 'Opera Mini', '5.1.22296', '5.1', 'Presto', '2.5.25', 'BlackBerry', :mobile_browser],
      ['Opera/9.80 (J2ME/MIDP; Opera Mini/5.1.22296/22.87; U; fr) Presto/2.5.25', 'Opera Mini', '5.1.22296', '5.1', 'Presto', '2.5.25', 'J2ME', :mobile_browser],
      ['Opera/9.80 (Windows Mobile; Opera Mini/5.1.21594/22.387; U; ru) Presto/2.5.25 Version/10.54', 'Opera Mini', '5.1.21594', '5.1', 'Presto', '2.5.25', 'Windows Mobile', :mobile_browser],
      ['Opera/9.80 (iPhone; Opera Mini/5.0.019802/22.414; U; de) Presto/2.5.25 Version/10.54', 'Opera Mini', '5.0.019802', '5.0', 'Presto', '2.5.25', 'iOS', :mobile_browser],
      ['Opera/9.80 (J2ME/MIDP; Opera Mini/SymbianOS/22.478; U; en) Presto/2.5.25 Version/10.54', 'Opera Mini', '10.54', '10.54', 'Presto', '2.5.25', 'Symbian OS', :mobile_browser],
      ['Opera/9.80 (J2ME/MIDP; Opera Mini/Nokia2730c-1/22.478; U; en) Presto/2.5.25 Version/10.54', 'Opera Mini', '10.54', '10.54', 'Presto', '2.5.25', 'J2ME', :mobile_browser],
      ['Opera/9.80 (J2ME/MIDP; Opera Mini/Mozilla/23.334; U; en) Presto/2.5.25 Version/10.54', 'Opera Mini', '10.54', '10.54', 'Presto', '2.5.25', 'J2ME', :mobile_browser],
      ['Opera/9.80 (J2ME/MIDP; Opera Mini/(Windows; U; Windows NT 5.1; en-US) AppleWebKit/23.411; U; en) Presto/2.5.25 Version/10.54', 'Opera Mini', '10.54', '10.54', 'Presto', '2.5.25', 'J2ME', :mobile_browser],
      ['Opera/9.60 (J2ME/MIDP; Opera Mini/4.1.11320/608; U; en) Presto/2.2.0', 'Opera Mini', '4.1.11320', '4.1', 'Presto', '2.2.0', 'J2ME', :mobile_browser],
      ['Opera/9.60 (J2ME/MIDP; Opera Mini/4.2.14320/554; U; cs) Presto/2.2.0', 'Opera Mini', '4.2.14320', '4.2', 'Presto', '2.2.0', 'J2ME', :mobile_browser],
      ['Opera/10.61 (J2ME/MIDP; Opera Mini/5.1.21219/19.999; en-US; rv:1.9.3a5) WebKit/534.5 Presto/2.6.30', 'Opera Mini', '5.1.21219', '5.1', 'Presto', '2.6.30', 'J2ME', :mobile_browser],
      ['Opera/9.80 (iPad; Opera Mini/6.1.15738/25.692; U; de) Presto/2.5.25 Version/10.54', 'Opera Mini', '6.1.15738', '6.1', 'Presto', '2.5.25', 'iOS', :mobile_browser],
      
      # Opera Mobile
      ['Opera/9.80 (J2ME/MIDP; Opera Mini/9.80 (S60; SymbOS; Opera Mobi/23.348; U; en) Presto/2.5.25 Version/10.54', 'Opera Mobile', '9.80', '9.80', 'Presto', '2.5.25', 'Symbian OS', :mobile_browser],
      ['Opera/9.80 (S60; SymbOS; Opera Mobi/SYB-1103211396; U; es-LA) Presto/2.7.81 Version/11.00', 'Opera Mobile', '11.00', '11.00', 'Presto', '2.7.81', 'Symbian OS', :mobile_browser],
      ['Opera/9.80 (Android; Linux; Opera Mobi/ADR-1012221546; U; pl) Presto/2.7.60 Version/10.5', 'Opera Mobile', '10.5', '10.5', 'Presto', '2.7.60', 'Android', :mobile_browser],
      ['Opera/9.80 (Android 2.2;;; Linux; Opera Mobi/ADR-1012291359; U; en) Presto/2.7.60 Version/10.5', 'Opera Mobile', '10.5', '10.5', 'Presto', '2.7.60', 'Android', :mobile_browser],
      ['Mozilla/4.0 (compatible; Windows Mobile; WCE; Opera Mobi/WMD-50433; U; de) Presto/2.4.13 Version/10.00', 'Opera Mobile', '10.00', '10.00', 'Presto', '2.4.13', 'Windows CE', :mobile_browser],
      ['Opera/9.80 (Windows NT 6.1; Opera Mobi/49; U; en) Presto/2.4.18 Version/10.00', 'Opera Mobile', '10.00', '10.00', 'Presto', '2.4.18', 'Windows', :mobile_browser],
      ['Opera/9.80 (Macintosh; Intel Mac OS X; Opera Mobi/27; U; en) Presto/2.4.18 Version/10.00', 'Opera Mobile', '10.00', '10.00', 'Presto', '2.4.18', 'OS X', :mobile_browser],
      ['Mozilla/5.0 (Linux armv7l; Maemo; Opera Mobi/4; U; fr; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6 Opera 10.1', 'Opera Mobile', '10.1', '10.1', 'Presto', '2.5.24', 'Maemo', :mobile_browser],
      ['Mozilla/4.0 (compatible; MSIE 8.0; Linux armv6l; Maemo; Opera Mobi/8; en-GB) Opera 11.00', 'Opera Mobile', '11.00', '11.00', 'Presto', '2.7.62', 'Maemo', :mobile_browser],
      ['Mozilla/4.0 (compatible; MSIE 8.0; Android 2.2.2; Linux; Opera Mobi/ADR-1103311355; en) Opera 11.00', 'Opera Mobile', '11.00', '11.00', 'Presto', '2.7.62', 'Android', :mobile_browser],
      ['Mozilla/4.0 (compatible; MSIE 6.0; S60; SymbOS; Opera Mobi/498; en) Opera 10.00', 'Opera Mobile', '10.00', '10.00', 'Presto', '2.4', 'Symbian OS', :mobile_browser],
      ['Opera/9.51 Beta (Microsoft Windows; PPC; Opera Mobi/1718; U; en)', 'Opera Mobile', '9.51', '9.51', 'Presto', '2.1', 'Windows Mobile', :mobile_browser],
      ['Opera/9.80 (S60; SymbOS; Opera Mobi/499; U; ru) Presto/2.4.18 Version/10.00', 'Opera Mobile', '10.00', '10.00', 'Presto', '2.4.18', 'Symbian OS', :mobile_browser],
      
      # Polaris
      ['POLARIS/6.01 (BREW 3.1.5; U; en-us; LG; LX265; POLARIS/6.01/WAP) MMP/2.0 profile/MIDP-2.1 Configuration/CLDC-1.1', 'Polaris', '6.01', '6.01', nil, nil, 'Brew', :mobile_browser],
  
      # Safari Mobile
      ['Mozilla/5.0 (iPod; U; CPU iPhone OS 4_2_1 like Mac OS X; he-il) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148 Safari/6533.18.5', 'Mobile Safari', '5.0.2', '5.0', 'WebKit', '533.17.9', 'iOS', :mobile_browser],
      ['Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_1 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8B117', 'Mobile Safari', '4.0.5', '4.0', 'WebKit', '532.9', 'iOS', :mobile_browser],
      ['Mozilla/5.0(iPad; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B314 Safari/123', 'Mobile Safari', '4.0.4', '4.0', 'WebKit', '531.21.10', 'iOS', :mobile_browser],     
      
      # Samsung Browser
      ['SEC-SGHE900/1.0 NetFront/3.2 Profile/MIDP-2.0 Configuration/CLDC-1.1 Opera/8.01 (J2ME/MIDP; Opera Mini/2.0.4509/1378; nl; U; ssr)', 'Opera Mini', '2.0.4509', '2.0', nil, nil, 'J2ME', :mobile_browser],     
      ['Mozilla/5.0 (Linux; U; Android 3.0.1; en-us; GT-P7100 Build/HRI83) AppleWebkit/534.13 (KHTML, like Gecko) Version/4.0 Safari/534.13', 'Mobile Safari', '4.0', '4.0', 'WebKit', '534.13', 'Android', :mobile_browser],     
      ['SAMSUNG-S8000/S8000XXIF3 SHP/VPP/R5 Jasmine/1.0 Nextreaming SMM-MMS/1.2.0 profile/MIDP-2.1 configuration/CLDC-1.1 FirePHP/0.3', 'MIDP Browser', '2.1', '2.1', nil, nil, 'J2ME', :mobile_browser],     
            
      # SEMC Browser
      ['SonyEricssonW700c/R1DB Browser/SEMC-Browser/4.2 Profile/MIDP-2.0 Configuration/CLDC-1.1', 'SonyEricsson Browser', '4.2', '4.2', nil, nil, 'J2ME', :mobile_browser],
      ['SonyEricssonK500c/R2L SEMC-Browser/4.0.1 Profile/MIDP-2.0 Configuration/CLDC-1.1', 'SonyEricsson Browser', '4.0.1', '4.0', nil, nil, 'J2ME', :mobile_browser],
      
      ['SonyEricssonT68/R201A', 'SonyEricsson Browser', nil, nil, nil, nil, 'J2ME', :mobile_browser],
      ['SonyEricssonT100/R101', 'SonyEricsson Browser', nil, nil, nil, nil, 'J2ME', :mobile_browser],
      ['SonyEricssonT610/R201 Profile/MIDP-1.0 Configuration/CLDC-1.0', 'SonyEricsson Browser', nil, nil, nil, nil, 'J2ME', :mobile_browser],
      ['SonyEricssonW950i/R100 Mozilla/4.0 (compatible; MSIE 6.0; Symbian OS; 323) Opera 8.60 [en-US]', 'Opera Mobile', '8.60', '8.60', 'Presto', '2.1', 'Symbian OS', :mobile_browser],
      ['SonyEricssonW995/R1EA Profile/MIDP-2.1 Configuration/CLDC-1.1 UNTRUSTED/1.0', 'SonyEricsson Browser', nil, nil, nil, nil, 'J2ME', :mobile_browser],
      ['Opera/9.5 (Microsoft Windows; PPC; Opera Mobi; U) SonyEricssonX1i/R2AA Profile/MIDP-2.0 Configuration/CLDC-1.1', 'Opera Mobile', '9.5', '9.5', 'Presto', '2.1', 'Windows Mobile', :mobile_browser],
      ['SonyEricssonZ800/R1Y Browser/SEMC-Browser/4.1 Profile/MIDP-2.0 Configuration/CLDC-1.1 UP.Link/6.3.0.0.0', 'SonyEricsson Browser', '4.1', '4.1', nil, nil, 'J2ME', :mobile_browser],
      
      # Skyfire (Android)
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_7; en-us) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Safari/530.17 Skyfire/2.0', 'Skyfire', '2.0', '2.0', 'WebKit', '530.17', 'Android', :mobile_browser],
      
      # TeaShark (MIDP)
      ['Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en) AppleWebKit/418.9.1 (KHTML, like Gecko) Safari/419.3 TeaShark/0.8', 'TeaShark', '0.8', '0.8', 'WebKit', '418.9.1', 'J2ME', :mobile_browser],
      
      # Teleca-Obigo
      ['Mozilla/5.0 (compatible; Teleca Q7; Brew 3.1.5; U; en) 480X800 LGE VX11000', 'Teleca-Obigo', 'Q7', 'Q7', nil, nil, 'Brew', :mobile_browser],
      
      # webOS
      ['Mozilla/5.0 (webOS/1.3; U; en-US) AppleWebKit/525.27.1 (KHTML, like Gecko) Version/1.0 Safari/525.27.1 Desktop/1.0', 'webOS Browser', '1.3', '1.3', 'WebKit', '525.27.1', 'webOS', :mobile_browser],
      
      # uZard Web
      ['Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.2; WOW64; Trident/4.0; uZardWeb/1.0; Server_USA)', 'uZard', '1.0', '1.0', 'Trident', '4.0', nil, :mobile_browser],
      ['Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.2; WOW64; Trident/4.0; uZard/1.0; Server_KO_SKT)', 'uZard', '1.0', '1.0', 'Trident', '4.0', nil, :mobile_browser],
      ['Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; WOW64; SV1; uZardWeb/1.0; Server_HK)', 'uZard', '1.0', '1.0', 'Trident', '3.0', nil, :mobile_browser],
       


      ### ToDo: Web Editors
      ### ToDo: Special Clients like iPhoto
      # iTunes/9.0.2 (Windows; N)
      # iTunes/4.2 (Macintosh; U; PPC Mac OS X 10.2)
  		# iTunes/9.0.3 (Macintosh; U; Intel Mac OS X 10_6_2; en-ca)
      ### ToDo: Mirror Tools like wget
      ### ToDo: Bots
      

      
      
    ].each do |agent|
      context "for '#{agent[0]}'" do
        it "should detect agent name as '#{agent[1]}'" do
          subject.request_header = agent[0]
          subject.guess_agent_type
          subject.name.should == agent[1]
        end
      
        it "should detect agent version as '#{agent[2]}'" do
          subject.request_header = agent[0]
          subject.guess_agent_type
          subject.full_version.should == agent[2]
        end
      
        it "should detect agent major version as '#{agent[3]}'" do
          subject.request_header = agent[0]
          subject.guess_agent_type
          subject.major_version.should == agent[3]
        end
        
        it "should detect agent engine name as '#{agent[4]}'" do
          subject.request_header = agent[0]
          subject.guess_agent_type
          subject.engine_name.should == agent[4]
        end
        
        it "should detect agent engine version as '#{agent[5]}'" do
          subject.request_header = agent[0]
          subject.guess_agent_type
          subject.engine_version.should == agent[5]
        end
      
        it "should detect agent os as '#{agent[6]}'" do
          subject.request_header = agent[0]
          subject.guess_agent_type
          subject.os.should == agent[6]
        end
      
        it "should detect agent class as '#{agent[7]}'" do
          subject.request_header = agent[0]
          subject.guess_agent_type
          subject.agent_class.should == agent[7]
        end
      end
      
    end
  end
end