module Gricer
  module Parsers
    class Agent
      # Guess the user agent data from the given agent_string and return the fields.
      def self.get_info agent_string
        info = {}
      
        agent_string.gsub!(/[UI];[ ]*/, '')

      
        void, info[:os], x11_os, comp_os = agent_string.match(/\(([A-Za-z0-9]*)(?:[^;]*)[; ]*([A-Za-z]*)(?:[^;]*)[; ]*([A-Za-z]*)/).to_a
      
        # if os is only a number it is probably a wrong found
        void, info[:os], x11_os, comp_os = agent_string.match(/\).*\(([A-Za-z0-9]*)(?:[^;]*)[; ]*([A-Za-z]*)(?:[^;]*)[; ]*([A-Za-z]*)/).to_a if  info[:os] =~ /^[0-9]*$/ 
      
        info[:os] = comp_os if info[:os] == 'compatible'
        info[:os] = x11_os if %w(Linux).include? info[:os] and ['Android'].include? x11_os
  			info[:os] = x11_os if %w(X11 Unknown PDA).include? info[:os] and not x11_os.blank?
  			info[:os] = 'Linux' if %w(Arch Gentoo).include? info[:os] and agent_string =~ /#{info[:os]} Linux/
  			info[:os] = 'Windows CE' if agent_string =~ /Windows CE/ or agent_string =~ /WindowsCE/
      
        if agent_string =~ /Opera[\/ ]/ or agent_string =~ /Opera$/
  				info[:name] = "Opera"
				
  				void, info[:full_version] = agent_string.match(/Version\/([0-9\.]*)/).to_a if agent_string =~ /Version\//			
  				void, info[:full_version] = agent_string.match(/Opera[\/ ]([0-9\.]*)/).to_a if info[:full_version].blank? or info[:full_version] =~ /^[0-9]+$/
				
  				if agent_string =~ /^[^\(]*\(compatible; MSIE/
  				  matches = agent_string.match /\(compatible; MSIE [0-9\.]*; ([a-zA-Z0-9]*)([a-zA-z0-9\ \/\._-]*)(?:; )?([a-zA-Z0-9]*)/
			  				
    				if matches
    				  info[:os] = matches[1]	
      				info[:os] = matches[3] if %w(X11 MSIE).include? info[:os]
      			end
    			end
  						
  			  info[:os] = "Nintendo Wii" if info[:os] == 'Nintendo'
  			
    			void, info[:full_version] = agent_string.match(/Opera ([0-9]+\.[0-9\.]+)/).to_a if info[:full_version].blank?
  			
    			if agent_string =~ /Opera Mobi[;\/]/
    			  info[:name] = 'Opera Mobile'
    			elsif agent_string =~ /Opera Mini\//
      			info[:name] = 'Opera Mini'
    			end
  			
    			void, mini_version = agent_string.match(/Opera Mini\/([0-9]+\.[0-9\.]+)/).to_a
    			info[:full_version] = mini_version unless mini_version.blank?

    			info[:agent_class] = :browser
  			
    			if ['Opera Mini', 'Opera Mobile'].include? info[:name]
    			  info[:agent_class] = :mobile_browser
  			  
  			    if agent_string =~ /BlackBerry/
  			      info[:os] = 'BlackBerry'
  			    elsif agent_string =~ /Android/
    			    info[:os] = 'Android'
    			  elsif agent_string =~ /Series 60/ or agent_string =~ /SymbOS/ or agent_string =~ /SymbianOS/  
    			    info[:os] = 'Symbian OS'
    			  elsif agent_string =~ /Windows Mobile; WCE;/
    			    info[:os] = 'Windows CE'
    			  elsif agent_string =~ /Windows Mobile;/ or agent_string =~ /Microsoft Windows;/
    			    info[:os] = 'Windows Mobile'
    			  elsif info[:os] == 'Linux' and agent_string =~ /Maemo/
    			    info[:os] = 'Maemo'
    			  elsif agent_string =~ /iPhone/ or agent_string =~ /iPad/ or agent_string =~ /iPod/
    			    info[:os] = 'iOS'
  			    end
  			  elsif info[:os] == 'Symbian'
  			    info[:name] = 'Opera Mobile'
  			    info[:agent_class] = :mobile_browser
  			  end
  			
    			if agent_string =~ /Presto\//
    			  void, info[:engine_version] = agent_string.match(/Presto\/([0-9]+\.[0-9\.]+)/).to_a
    			  info[:engine_name] = 'Presto'
    			elsif (version = info[:full_version].to_f) >= 7.0
    			  info[:engine_name] = 'Presto'
  			  
    			  if version > 11.6
    			    info[:engine_version] = nil
    			  elsif version >= 11.5 
    			    info[:engine_version] = '2.9.168'
    			  elsif version >= 11.1
    			    info[:engine_version] = '2.8.131'
    			  elsif version >= 11.0
    			    info[:engine_version] = '2.7.62'
    			  elsif info[:name] == 'Opera' 
    			    if version >= 10.6
    			      info[:engine_version] = '2.6.30'
    			    elsif version >= 10.5
    			      info[:engine_version] = '2.5.24'
    			    elsif version >= 10.0
    			      info[:engine_version] = '2.2.15'
    			    elsif version >= 9.6
    			      info[:engine_version] = '2.1.1'
    			    elsif version >= 9.5
    			      info[:engine_version] = '2.1'
    			    elsif version >= 9.0
    			      info[:engine_version] = '2.0'
    			    else
    			      info[:engine_version] = '1.0'
    			    end
  			    elsif info[:name] == 'Opera Mobile'
  		        if version >= 10.1
  		          info[:engine_version] = '2.5.24'
  		        elsif version >= 10
  		          info[:engine_version] = '2.4'
  		        elsif version >= 9.8
  		          info[:engine_version] = '2.2.15'
  		        elsif version >= 9.7
  		          info[:engine_version] = '2.2'
  		        else
  		          info[:engine_version] = '2.1'
  		        end
    			  end
   			  end
   			elsif agent_string =~ /AppleWeb[kK]it/			
  			  info[:name] = "WebKit Browser"
  			  info[:engine_name] = 'WebKit'
  			  void, info[:engine_version] = agent_string.match(/AppleWeb[kK]it\/([0-9\.]*)/).to_a
	
			  	
  				if agent_string =~ /Mobile/ || agent_string =~ /Android/ || agent_string =~ / Pre\// and not agent_string =~ /Series60\//
  					info[:name] = "Mobile Safari"
					
  					void, info[:full_version] = agent_string.match(/Version\/([0-9\.]*)/).to_a
					
  					if ['iPod', 'iPhone', 'iPad'].include? info[:os]
  						info[:os] = 'iOS'
  					elsif info[:os] =~ /webOS/
  						info[:os]='Palm webOS'
  					elsif info[:os] == 'BlackBerry'
  					  info[:name] = 'BlackBerry Browser'
  					end
					
  					if agent_string =~ /Dorothy/
  					  info[:name] = 'Dorothy'	  
    					info[:os] = 'Windows CE' if info[:os] == 'Windows'
  					end					
					
  					info[:agent_class] = :mobile_browser
  			  elsif agent_string =~ /ABrowse/
    		    info[:name] = "ABrowse"	
    				void, info[:full_version] = agent_string.match(/ABrowse ([0-9\.]*)/).to_a
    				info[:agent_class] = :browser
    			elsif agent_string =~ /[Ee]piphany/
    				info[:name] = "Epiphany"
    				void, info[:full_version] = agent_string.match(/Epiphany\/([0-9\.]*)/).to_a
    				info[:agent_class] = :browser
    			elsif agent_string =~ /OmniWeb/
    				info[:name] = "OmniWeb"
    				void, info[:full_version] = agent_string.match(/OmniWeb\/v([0-9\.]*)/).to_a
    				info[:os] = 'OS X'
    				info[:agent_class] = :browser  				
  				else	
  				  chrome_aliases = %w(Chromium Iron)
  				  webkit_browsers = ['QtWeb Internet Browser'] + %w(Arora Flock Fluid Hana RealPlayer Shiira Stainless SunriseBrowser Sunrise Skyfire TeaShark BOLT Series60 webOS Chrome) + chrome_aliases
				  
            info[:agent_class] = :browser
				  
  				  webkit_browsers.each do |agent|
              if agent_string =~ /#{agent}/
                if chrome_aliases.include?(agent)
                  info[:name] = 'Chrome'
                else
      				    info[:name] = agent
      				  end
      				  void, info[:full_version] = agent_string.match(/#{agent}\/([0-9\.]*)/).to_a
      				  void, info[:full_version] = agent_string.match(/Version\/([0-9\.]*)/).to_a if info[:full_version].blank?
      				  break
              end
            end
          end	
        
          info[:name] = 'Sunrise' if info[:name] == 'SunriseBrowser'
          info[:name] = 'Bolt' if info[:name] == 'BOLT'
          if info[:name] == 'Series60' or info[:os] == 'SymbianOS'
            info[:name] = 'Browser for S60' 
            info[:agent_class] = :mobile_browser
          end
        
          if info[:name] == 'webOS'
            info[:name] = 'webOS Browser' 
            info[:agent_class] = :mobile_browser
          end
        
          if %w(Skyfire).include? info[:name]
            info[:os] = 'Android'
            info[:agent_class] = :mobile_browser
          elsif %w(TeaShark Bolt).include? info[:name]
            info[:os] = 'J2ME'
            info[:agent_class] = :mobile_browser
          end
					
  				if agent_string =~ /Safari/ and info[:name] == "WebKit Browser"
  					info[:name] = "Safari"
					
  					void, info[:full_version] = agent_string.match(/Version\/([0-9\.]*)/).to_a
					
  					unless info[:full_version]
  					  void, webkit_version = agent_string.match(/Safari\/([0-9\.]*)/).to_a
						
  						info[:full_version] = case webkit_version 
  				    when /^85\.8(?:\.1)?$/ then '1.0.3'
  				    when /^85(?:\.[567])?$/ then '1.0'
  				    when /^125(?:\.1)?$/ then '1.2'
  				    when /^125\.[278]$/ then '1.2.2'
  				    when /^125\.5\.5$/ then '1.2.2'
  				    when /^125\.9$/ then '1.2.3'
  				    when /^125\.1[12]$/ then '1.2.4'
  				    when /^312$/ then '1.3'
    				  when /^312\.3(?:\.[13])?$/ then '1.3.1'
    				  when /^312\.[56]$/ then '1.3.2'
    				  when /^412(?:\.[2])*$/ then '2.0'
    				  when /^412\.[567]$/ then '2.0.1'
    				  when /^413$/ then '2.0.1'
    				  when /^416\.1[23]$/ then '2.0.2'
    				  when /^417\.8$/ then '2.0.3'
    				  when /^417\.9\.[23]$/ then '2.0.3'
    				  when /^419.3$/ then '2.0.4'
  					  end
            end
  				end
				
  			elsif agent_string =~ /Konqueror/
    			  info[:name] = "Konqueror"	
    			  void, info[:full_version] = agent_string.match(/Konqueror[\/ ]([0-9\.]*)/).to_a
          	void, info[:os] = agent_string.match(/Konqueror[^;]*; (?:i[36]86 )?([A-Za-z0-9]*)/).to_a
          	info[:os] = nil if info[:os] == 'X11'
          	info[:engine_name] = 'KHTML'
          	void, info[:engine_version] = agent_string.match(/KHTML[\/ ]([0-9\.]*)/).to_a
          	info[:engine_version] = info[:full_version] if info[:engine_version].blank?
          	info[:agent_class] = :browser
		  
				      
  			elsif agent_string =~ /Gecko/
  				info[:name] = "Gecko Browser";
				
  				real_agent = nil
  				info[:agent_class] = :browser
				
  				firefox_aliases = %w(Firebird Minefield BonEcho Iceweasel Shiretoko GranParadiso IceCat Iceweasel IceWeasel Namoroka Phoenix)
  				gecko_browsers = %w(BeZillaBrowser Beonex Camino Chimera Conkeror Epiphany Flock Galeon Iceape K-Meleon K-Ninja Kapiko Kazehakase KMLite MultiZilla SeaMonkey Netscape Navigator Prism Fennec Minimo Firefox) + firefox_aliases
				
  				agent_string = agent_string.gsub('prism', 'Prism')
				
  				gecko_browsers.each do |agent|
  				  if agent_string =~ /#{agent}/
  				    info[:name] = agent
      				break
      			end
  			  end
			  
  			  info[:engine_name] = 'Gecko'
  			  void, info[:engine_version] = agent_string.match(/rv:([0-9\.]*)/).to_a

  	      if info[:name] == "Gecko Browser"   
  	        info[:full_version] = info[:engine_version]
  	      else
  	        void, info[:full_version] = agent_string.match(/#{info[:name]}\/([0-9\.]*)/).to_a
          end
        
          info[:name] = 'Netscape Navigator' if %w(Netscape Navigator).include? info[:name]
          info[:name] = 'Firefox' if firefox_aliases.include? info[:name]
  			
  				if agent_string =~ /Maemo Browser[\/ ][0-9]/
  				  info[:name] = 'Maemo Browser'
  				  void, info[:full_version] = agent_string.match(/Maemo Browser[\/ ]([0-9\.]*)/).to_a
  			    info[:os] = 'Maemo'
  			    info[:agent_class] = :mobile_browser
  			  end
			  
  			  if %w(Fennec Minimo).include? info[:name]
  			    info[:agent_class] = :mobile_browser
  		    end  
 			
   			elsif agent_string =~ /Series60\//
  				info[:name] = 'Browser for S60'
  				info[:os] = 'Symbian OS'
  				void, info[:full_version] = agent_string.match(/Series60\/([0-9\.]*)/).to_a
  				info[:agent_class] = :mobile_browser
  			elsif agent_string =~ /Series80\//
  				info[:name] = 'Browser for S80'
  				info[:os] = 'Symbian OS'
  				void, info[:full_version] = agent_string.match(/Series80\/([0-9\.]*)/).to_a
  				info[:agent_class] = :mobile_browser
			
        elsif agent_string =~ /compatible; MSIE/
  				info[:name] = "Internet Explorer"
				
  				void, info[:full_version], info[:os] = agent_string.match(/MSIE ([0-9\.]*)(?:b[0-9]*)?; ([A-Za-z]*)/).to_a
				
  				if info[:os] == 'Mac'
  					info[:os] = 'Macintosh'
  				elsif info[:os] != 'Windows' and agent_string =~ /Windows/
  				  info[:os] = 'Windows'
  				end
  				info[:agent_class] = :browser
				
  				if agent_string =~ /IEMobile[\/ ][0-9]/
  			    info[:name] = 'IE Mobile'
  			    info[:agent_class] = :mobile_browser
  			    void, info[:full_version]= agent_string.match(/IEMobile[\/ ]([0-9\.]*)/).to_a
  			    void, info[:os] = agent_string.match(/(Windows [A-Za-z0-9]*)/).to_a
  			  end
				
  				if agent_string =~ /Trident\//
    			  void, info[:engine_version] = agent_string.match(/Trident\/([0-9]+\.[0-9\.]+)/).to_a
    			  info[:engine_name] = 'Trident'
  				elsif (version = info[:full_version].to_f) >= 4
  				  info[:engine_name] = 'Trident'
  				  if version > 10.0
  				    info[:engine_version] = nil
  				  elsif version >= 10.0
  				    info[:engine_version] = '6.0'
  				  elsif version >= 9.0
  				    info[:engine_version] = '5.0'
  				  elsif version >= 8.0
  				    info[:engine_version] = '4.0'
  				  elsif version >= 7.0
  				    info[:engine_version] = '3.1'
  				  elsif version >= 6.0
  				    info[:engine_version] = '3.0'
  				  elsif version >= 5.5
  				    info[:engine_version] = '2.2'
  				  elsif version >= 5.1
  				    info[:engine_version] = '2.1'
  				  elsif version >= 5.0
  				    info[:engine_version] = '2.0'
  			    else
  			      info[:engine_version] = '1.0'
  		      end
		      
  		      if agent_string =~ /Windows CE;/ and agent_string =~ /[pP]rofile\/MIDP/
  		        info[:name] = 'IE Mobile'
    			    info[:os] = 'Windows CE'
    			    info[:agent_class] = :mobile_browser
  			    end		  
  			  end
				
  				if agent_string =~ /Avant Browser/
  				  info[:name] = 'Avant Browser'
  				  info[:full_version] = nil
  				elsif agent_string =~ /PalmSource[^;]*; Blazer/
  				  info[:name] = 'Blazer'
  				  void, info[:full_version] = agent_string.match(/Blazer[\/ ]([0-9\.]*)/).to_a
  				  info[:engine_name] = nil
  				  info[:engine_version] = nil
  			    info[:os] = 'Palm OS'
  			    info[:agent_class] = :mobile_browser
  				elsif agent_string =~ /EudoraWeb/
  				  info[:name] = 'EudoraWeb'
  				  void, info[:full_version] = agent_string.match(/EudoraWeb ([0-9\.]*)/).to_a
  				  info[:engine_name] = nil
  				  info[:engine_version] = nil
  				  info[:agent_class] = :mobile_browser
  			  elsif agent_string =~ /uZard(?:Web)?[\/ ][0-9]/
  			    info[:name] = 'uZard'
  			    void, info[:full_version]= agent_string.match(/uZard(?:Web)?[\/ ]([0-9\.]*)/).to_a
  			    info[:os] = nil
  			    info[:agent_class] = :mobile_browser
  			  end

				
  			# Rare Browsers
						
  			elsif agent_string =~ /ABrowse/
  			  # Old version of ABrowse don't include AppleWebKit in agent_string
  		    info[:name] = "ABrowse"	
  				void, info[:full_version], info[:os] = agent_string.match(/ABrowse ([0-9\.]*)(?:[a-zA-z0-9\ \/\._-]*); ([a-zA-Z0-9]*)/).to_a
  				info[:agent_class] = :browser
  			elsif agent_string =~ /amaya\//
  				info[:name] = "Amaya"
  				void, info[:full_version] = agent_string.match(/amaya\/([0-9\.]*)/).to_a
  				info[:agent_class] = :browser  			
  			elsif agent_string =~ /AmigaVoyager/
  			  info[:name] = "AmigaVoyager"	
  			  info[:os] = "AmigaOS"
        	void, info[:full_version] = agent_string.match(/AmigaVoyager\/([0-9\.]*)/).to_a
        	info[:agent_class] = :browser    
  			elsif agent_string =~ /^Avant Browser/
  			  info[:name] = "Avant Browser"	
  			  info[:os] = 'Windows'
        	void, info[:full_version] = agent_string.match(/Avant Browser\/([0-9\.]*)/).to_a
        	info[:agent_class] = :browser          	
  			elsif agent_string =~ /\(Charon;/
  			  info[:name] = "Charon"	
  				void, info[:os] = agent_string.match(/\(Charon; (.*)\)/).to_a
  				info[:agent_class] = :browser
  			elsif agent_string =~ /Cyberdog/
  			  info[:name] = "Cyberdog"	
  			  info[:os] = "Classic Macintosh"
        	void, info[:full_version] = agent_string.match(/Cyberdog\/([0-9\.]*)/).to_a
        	info[:agent_class] = :browser
        elsif agent_string =~ /Dillo\//
  				info[:name] = "Dillo"
  				void, info[:full_version] = agent_string.match(/Dillo\/([0-9\.]*)/).to_a
  				info[:agent_class] = :browser
        elsif agent_string =~ /E[lL]inks/
  			  info[:name] = "ELinks"	
  			  void, info[:os] = agent_string.match(/;\s?([A-Za-z0-9]*)(?:[\+a-zA-z0-9\s\/\._-]*);\s?[0-9]+x[0-9]+/).to_a
        	void, info[:full_version] = agent_string.match(/E[lL]inks\/([0-9\.]*)/).to_a
        	void, info[:full_version] = agent_string.match(/E[lL]inks \(([0-9\.]*)/).to_a if info[:full_version].blank?
        	info[:agent_class] = :browser	
        elsif agent_string =~ /Galaxy/
  			  info[:name] = "Galaxy"	
  			  void, info[:os] = agent_string.match(/\(([A-Za-z0-9]*)/).to_a
        	void, info[:full_version] = agent_string.match(/Galaxy[\/ ]([0-9\.]*)/).to_a
        	info[:agent_class] = :browser	
        elsif agent_string =~ /HotJava/
  			  info[:name] = "HotJava"	
        	void, info[:full_version] = agent_string.match(/HotJava[\/ ]([0-9\.]*)/).to_a
        	info[:agent_class] = :browser	
        elsif agent_string =~ /IBM WebExplorer/
  			  info[:name] = "IBM WebExplorer"	
  			  info[:os] = 'OS/2'
        	void, info[:full_version] = agent_string.match(/\/v([0-9\.]*)/).to_a
        	info[:agent_class] = :browser	
        elsif agent_string =~ /IBrowse/
  			  info[:name] = "IBrowse"	
  			  info[:os] = 'AmigaOS'
        	void, info[:full_version] = agent_string.match(/IBrowse[\/ ]([0-9\.]*)/).to_a
        	info[:agent_class] = :browser	
        elsif agent_string =~ /iCab/
  			  info[:name] = "iCab"	
  			  info[:os] = 'OS X'
        	void, info[:full_version] = agent_string.match(/iCab[\/ ]([0-9\.]*)/).to_a
        	info[:agent_class] = :browser	
        elsif agent_string =~ /^Links/
  				info[:name] = "Links"
  				void, info[:full_version] = agent_string.match(/Links (?:\()?([0-9\.]*)/).to_a
  				void, info[:os] = agent_string.match(/Links[^;]*; ([A-Za-z0-9]*)/).to_a
  				info[:os] = nil if info[:os] == 'Unix'
  				info[:os] = 'Macintosh' if info[:os] == 'Darwin'
  				info[:agent_class] = :browser
        elsif agent_string =~ /^Lynx/
  				info[:name] = "Lynx"
  				info[:os] = nil
  				void, info[:full_version] = agent_string.match(/Lynx\/([0-9\.]*)/).to_a
  				info[:agent_class] = :browser
  			elsif agent_string =~ /Midori\/[0-9]/
  			  info[:name] = "Midori"
  			  void, info[:full_version] = agent_string.match(/Midori\/([0-9\.]*)/).to_a
  			  info[:engine_name] = 'WebKit'
  			  void, info[:engine_version] = agent_string.match(/WebKit\/\(([0-9\.]*)/).to_a
  			  info[:agent_class] = :browser
  			elsif agent_string =~ /^NCSA[_ ]Mosaic\//
  			  info[:name] = "Mosaic"
  				void, info[:full_version] = agent_string.match(/Mosaic\/([0-9\.]*)/).to_a
  				void, info[:os] = agent_string.match(/\((?:X11;[ ]?)?([A-Za-z0-9]*)/).to_a
  				info[:os] = nil if info[:os] == 'Unix'
  				info[:os] = 'Macintosh' if info[:os] == 'Darwin'
  				info[:agent_class] = :browser
  			elsif agent_string =~ /neon\//
  				info[:name] = "Neon"
  				void, info[:full_version] = agent_string.match(/neon\/([0-9\.]*)/).to_a
  				info[:agent_class] = :browser
  			elsif agent_string =~ /NetPositive\//
  				info[:name] = "NetPositive"
  				void, info[:full_version] = agent_string.match(/NetPositive\/([0-9\.]*)/).to_a
  				info[:agent_class] = :browser				
  			elsif agent_string =~ /NetSurf\//
  				info[:name] = "NetSurf"
  				void, info[:full_version] = agent_string.match(/NetSurf\/([0-9\.]*)/).to_a
  				info[:agent_class] = :browser
  			elsif agent_string =~ /OmniWeb\//
  				info[:name] = "OmniWeb"
  				void, info[:full_version] = agent_string.match(/OmniWeb\/([0-9\.]*)/).to_a
  				info[:os] = 'OS X'
  				info[:agent_class] = :browser
  			elsif agent_string =~ /^w3m[\/ ]?/
  			  info[:name] = 'w3m'
  			  void, info[:full_version] = agent_string.match(/w3m[\/ ]([0-9\.]*)/).to_a
  			  info[:full_version] = '0.5.2' if info[:full_version] == '0.52'
  			  void, info[:os] = agent_string.match(/\(([A-Za-z0-9]*)/).to_a
  			  info[:os] = 'Linux' if info[:os] == 'Debian'
  			  info[:agent_class] = :browser
  			elsif agent_string == 'WorldWideweb (NEXT)'
  			  info[:name] = 'WorldWideweb'
  			  info[:os] = 'NeXT OS'
  			  info[:agent_class] = :browser
  			elsif agent_string =~ /Yandex\//
  				info[:name] = "Yandex"
  				void, info[:full_version] = agent_string.match(/Yandex\/([0-9\.]*)/).to_a
  				info[:os] = 'Windows'
  				info[:agent_class] = :browser
				
  			# Console Browsers	
				
  			elsif agent_string =~ /Bunjalloo\//
  			  info[:name] = "Bunjalloo"
  				void, info[:full_version] = agent_string.match(/Bunjalloo\/([0-9\.]*)/).to_a
  				void, info[:os] = agent_string.match(/\(([A-Za-z0-9 ]*)/).to_a
  				info[:agent_class] = :browser
  			elsif agent_string =~ /\(PLAYSTATION 3/
  			  info[:name] = "Playstation 3"
  				void, info[:full_version] = agent_string.match(/PLAYSTATION 3; ([0-9\.]*)/).to_a
  				info[:os] = "Playstation 3"
  				info[:agent_class] = :browser
  			elsif agent_string =~ /\(PS3 \(PlayStation 3\)/
  			  info[:name] = "Playstation 3"
  				void, info[:full_version] = agent_string.match(/\(PS3 \(PlayStation 3\); ([0-9\.]*)/).to_a
  				info[:os] = "Playstation 3"
  				info[:agent_class] = :browser
  			elsif agent_string =~ /PSP \(PlayStation Portable\)/
  			  info[:name] = "PlayStation Portable"
  				void, info[:full_version] = agent_string.match(/PSP \(PlayStation Portable\); ([0-9\.]*)/).to_a
  				info[:os] = "PlayStation Portable"
  				info[:agent_class] = :browser
  			elsif agent_string =~ /wii libnup/
  			  info[:name] = "Wii Browser"
  				void, info[:full_version] = agent_string.match(/wii libnup\/([0-9\.]*)/).to_a
  				info[:os] = "Nintendo Wii"
  				info[:agent_class] = :browser
				
  			# Mobile Browsers
				
  			elsif agent_string =~ /^BlackBerry/
  			  info[:name] = "BlackBerry Browser"
  				void, info[:full_version] = agent_string.match(/^BlackBerry[0-9]*[i]*\/([0-9\.]*)/).to_a
  				info[:os] = "BlackBerry"
  				info[:agent_class] = :mobile_browser		
  			elsif agent_string =~ /portalmmm\//
    			info[:name] = "IMode mobile browser"
    			void, info[:full_version] = agent_string.match(/portalmmm\/([0-9\.]*)/).to_a
    			info[:os] = nil
    			info[:agent_class] = :mobile_browser
  			elsif agent_string =~ /^Doris/
  			  info[:name] = "Doris"
  				void, info[:full_version] = agent_string.match(/^Doris\/([0-9\.]*)/).to_a
  				info[:os] = "SymbianOS"
  				info[:agent_class] = :mobile_browser
  			elsif agent_string =~ /\/GoBrowser/
  			  info[:name] = "GoBrowser"
  				void, info[:full_version] = agent_string.match(/\/GoBrowser\/([0-9\.]*)/).to_a
  				void, info[:os] = agent_string.match(/\(([A-Za-z0-9]*)/).to_a
  				info[:agent_class] = :mobile_browser
  			elsif agent_string =~ /MIB\/[0-9]/
  			  info[:name] = "Motorola Internet Browser"
  				void, info[:full_version] = agent_string.match(/MIB\/([0-9\.]*)/).to_a
  				info[:os] = 'J2ME'
  				info[:agent_class] = :mobile_browser
  			elsif agent_string =~ /UP.Browser\//
  			  info[:name] = "UP Browser"
  				void, info[:full_version] = agent_string.match(/UP.Browser\/([0-9\.]*)/).to_a
  				info[:os] = 'J2ME'
  				info[:agent_class] = :mobile_browser
  			elsif agent_string =~ /NetFront\/[0-9]/
  			  info[:name] = "NetFront"
  				void, info[:full_version] = agent_string.match(/NetFront\/([0-9\.]*)/).to_a
  				info[:os] = 'Kindle' if agent_string =~ /Kindle\/[0-9]/
  				info[:agent_class] = :mobile_browser
  			elsif agent_string =~ /POLARIS\/[0-9]/
  			  info[:name] = "Polaris"
  				void, info[:full_version] = agent_string.match(/POLARIS\/([0-9\.]*)/).to_a
  				info[:agent_class] = :mobile_browser
  			elsif agent_string =~ /SEMC-Browser\//
  				info[:name] = "SonyEricsson Browser"
  				info[:os] = 'J2ME'
  				void, info[:full_version] = agent_string.match(/SEMC-Browser\/([0-9\.]*)/).to_a
  				info[:agent_class] = :mobile_browser
  			elsif agent_string =~ /Teleca/
  			  info[:name] = "Teleca-Obigo"
    			void, info[:full_version], info[:os] = agent_string.match(/Teleca[\/ ]([A-Z0-9\.]*)(?:; )?([A-Za-z0-9]*)/).to_a
    			info[:agent_class] = :mobile_browser
			  
    		elsif agent_string =~ /^SonyEricsson/
    		  info[:name] = "SonyEricsson Browser"
  			  info[:os] = 'J2ME'
  			  info[:agent_class] = :mobile_browser
  			elsif agent_string =~ /[pP]rofile\/MIDP-/
  			  info[:name] = "MIDP Browser"
  			  info[:os] = 'J2ME'
    			void, info[:full_version] = agent_string.match(/[pP]rofile\/MIDP-([A-Za-z0-9\.]*)/).to_a
    			info[:agent_class] = :mobile_browser
			  
  			# Known Bots									
  			elsif agent_string =~ /Yahoo! Slurp/
  				info[:name] = "Yahoo! Bot"
  				info[:agent_class] = :bot										
  			elsif agent_string =~ /Googlebot/ || agent_string =~ /Google-Sitemaps/
  				info[:name] = "Google Bot"
  				info[:agent_class] = :bot										
  			elsif agent_string =~ /ia_archiver/
  				info[:name] = "Internet Archive Bot"
  				info[:agent_class] = :bot										
  			elsif agent_string =~ /msnbot/
  				info[:name] = "MSN Live Search Bot"
  				info[:agent_class] = :bot										
  			elsif agent_string =~ /ScoutJet/
  				info[:name] = "ScoutJet Bot"
  				info[:agent_class] = :bot										
  			elsif agent_string =~ /Ask Jeeves/
  				info[:name] = "Ask Jeeves Bot"
  				info[:agent_class] = :bot										
  			elsif agent_string =~ /AboutUsBot/
  				info[:name] = "AboutUsBot"
  				info[:agent_class] = :bot										
  			elsif agent_string =~ /NaverBot/
  				info[:name] = "NaverBot"
  				info[:agent_class] = :bot										
  			elsif agent_string =~ /Gigabot/
  				info[:name] = "Gigabot"
  				info[:agent_class] = :bot										
  			elsif agent_string =~ /CyberPatrol SiteCat/
  				info[:name] = "CyberPatrol Bot"
  				info[:agent_class] = :bot										
  			elsif agent_string =~ /BLT/
  				info[:name] = "BLT"
  				info[:agent_class] = :bot										
  			elsif agent_string =~ /Netluchs/
  				info[:name] = "Netluchs"
  				info[:agent_class] = :bot										
  			elsif agent_string =~ /blackspider/
  				info[:name] = "Blackspider"
  				info[:agent_class] = :bot						
  			elsif agent_string =~ /Yanga WorldSearch Bot/
  				info[:name] = "Yanga WorldSearch Bot"
  				void, info[:full_version] = agent_string.match(/v([0-9\.]*)/).to_a
  				info[:agent_class] = :bot				
  			elsif agent_string=~ /Twiceler/
  				info[:name] = "Twiceler"
  				void, info[:full_version] = agent_string.match(/Twiceler-([0-9\.]*)/).to_a
  				info[:agent_class] = :bot				
  			elsif agent_string =~ /WebDataCentreBot/
  				info[:name] = "WebDataCentreBot"
  				void, info[:full_version] = agent_string.match(/WebDataCentreBot\/([0-9\.]*)/).to_a
  				info[:agent_class] = :bot			
  			elsif agent_string =~ /DomainCrawler/
  				info[:name] = "DomainCrawler"
  				void, info[:full_version] = agent_string.match(/DomainCrawler\/([0-9\.]*)/).to_a
  				info[:agent_class] = :bot			
  			elsif agent_string =~ /NetcraftSurveyAgent/
  				info[:name] = "NetcraftSurveyAgent"
  				void, info[:full_version] = agent_string.match(/NetcraftSurveyAgent\/([0-9\.]*)/).to_a
  				info[:agent_class] = :bot			
  			elsif agent_string =~ /Snapbot/	
  				info[:name] = "Snapbot"
  				void, info[:full_version] = agent_string.match(/Snapbot\/([0-9\.]*)/).to_a
  				info[:agent_class] = :bot			
  			elsif agent_string =~ /Jyxobot/
  				info[:name] = "Jyxobot"
  				void, info[:full_version] = agent_string.match(/Jyxobot\/([0-9\.]*)/).to_a
  				info[:agent_class] = :bot			
  			elsif agent_string =~ /Speedy Spider/
  				info[:name] = "Speedy Spider"
  				info[:agent_class] = :bot			
  			elsif agent_string =~ /iPhoto/
  				info[:name] = "iPhoto"
  				void, info[:full_version], info[:os] = agent_string.match(/iPhoto\/([0-9\.]*) \(([A-Za-z1-9]*);/).to_a
  				info[:agent_class] = :browser							
  			elsif agent_string =~ /mylinkcheck/
  				info[:name] = "MyLinkCheck"
  				void, info[:full_version] = agent_string.match(/mylinkcheck\/([0-9\.]*)/).to_a
  				info[:agent_class] = :bot				
  			elsif agent_string =~ /W3C-checklink/
  				info[:name] = "W3C-checklink"
  				void, info[:full_version] = agent_string.match(/W3C-checklink\/([0-9\.]*)/).to_a
  				info[:agent_class] = :bot				
  			elsif agent_string =~ /Eurobot/
  				info[:name] = "Eurobot"
  				void, info[:full_version] = agent_string.match(/Eurobot\/([0-9\.]*)/).to_a
  				info[:agent_class] = :bot				
  			elsif agent_string =~ /JoeDog\//
  				info[:name] = "JoeDog"
  				void, info[:full_version] = agent_string.match(/JoeDog\/([0-9\.]*)/).to_a
  				info[:agent_class] = :bot
  			elsif agent_string =~ /W3C_Validator\//
  				info[:name] = "W3C_Validator"
  				void, info[:full_version] = agent_string.match(/W3C_Validator\/([0-9\.]*)/).to_a
  				info[:agent_class] = :bot
  			elsif agent_string =~ /Wget\//
  				info[:name] = "Wget"
  				void, info[:full_version] = agent_string.match(/Wget\/([0-9\.]*)/).to_a
  				info[:agent_class] = :bot
			
  			elsif agent_string =~ /WebAlta Crawler\//
  				info[:name] = "WebAlta Crawler"
  				void, info[:full_version] = agent_string.match(/WebAlta Crawler\/([0-9\.]*)/).to_a
  				info[:agent_class] = :bot
  			elsif agent_string =~ /WebAlta Crawler\//
  				info[:name] = "WebAlta Crawler"
  				void, info[:full_version] = agent_string.match(/WebAlta Crawler\/([0-9\.]*)/).to_a
  				info[:agent_class] = :bot
  			elsif agent_string =~ /WWW-Mechanize\//
  				info[:name] = "WWW-Mechanize";
  				void, info[:full_version] = agent_string.match(/WWW-Mechanize\/([0-9\.]*)/).to_a
  				info[:agent_class] = :bot
  			elsif agent_string =~ /Serverstress Analysis Software/
  				info[:name] = 'Serverstress Analysis Software'
  				info[:agent_class] = :bot

  			elsif agent_string =~ /Java\//
  				info[:name] = 'Java Client';
  				info[:os] = nil
  				void, info[:full_version] = agent_string.match(/Java\/([0-9\.]*)/).to_a
  				info[:agent_class] = :bot
  			elsif agent_string.strip == 'http://www.uni-koblenz.de/~flocke/robot-info.txt'
  				info[:name] = 'http://www.uni-koblenz.de/~flocke/robot-info.txt'
  				info[:agent_class] = :bot
  			elsif agent_string =~ /^Shelob/
  				info[:name] = 'Shelob';
  				info[:agent_class] = :bot
  			end
		
  			# Cleanup
			
  			info[:full_version] = "#{info[:full_version]}0" if info[:full_version] =~ /^[0-9]+\.$/
  			info[:full_version] = "#{info[:full_version]}.0" if info[:full_version] =~ /^[0-9]+$/
  			info[:os] = 'OS X' if ['Macintosh', 'Mac'].include? info[:os]
  			info[:os] = 'Windows' if info[:os] == 'Win'
  			info[:os] = 'Symbian OS' if %w(Symbian SymbianOS).include? info[:os] 
  			info[:os] = 'J2ME' if info[:os] == 'J2ME/MIDP'
  			info[:os] = 'Brew' if info[:os] == 'BREW'
			
  			info[:full_version] = nil if info[:full_version].blank?
  			info[:full_version].sub!(/\.$/,'') if info[:full_version] 
  			info[:major_version] = info[:full_version].match(/^([0-9]*\.[0-9]*)/).to_a.last if info[:full_version]
  			info[:major_version] = info[:full_version] if info[:major_version].blank?
			
  			return info
      end
    end
  end
end