module Gricer  
  # ActiveRecord Model for User Agent Statistics
  # @attr [String] request_header
  #   The  current value of user agent string as within the HTTP request.
  #
  # @attr [String] name
  #   The current value of user agent's name.
  #   (e.g. 'Firefox', 'Chrome', 'Internet Explorer')
  #
  # @attr [String] full_version
  #   The current value of user agent's full version.
  #   This means it does include all sub version numbers.
  #
  # @attr [String] major_version
  #   The current value of user agent's major version.
  #   This means it does include only the first number after a dot.
  #
  # @attr [String] engine_name
  #   The current value of the name of the engine used by the user agent
  #
  # @attr [String] engine_version
  #   The current value of the version of the engine used by the user agent
  #
  # @attr [String] os
  #   The current value of the OS the user agent is hosted on.
  #
  # @attr [String] agent_class
  #   The current value of the classification of the user agent. 
  #
  #   See {AGENT_CLASSES} for possible values.
  class Agent < ::ActiveRecord::Base    
    self.table_name = "#{::Gricer::config.table_name_prefix}agents"
    include ActiveModel::Statistics
    
    has_many :requests, class_name: 'Gricer::Request', foreign_key: :agent_id, order: 'created_at ASC'
    has_many :sessions, class_name: 'Gricer::Session', foreign_key: :session_id, order: 'created_at ASC'
    
    before_create :guess_agent_type
    
    # The agent class constant defines numeric values for the different agent types to be stored in a database.
    AGENT_CLASSES = {
      0x1000 => :browser,
      0x2000 => :mobile_browser,
      0x0001 => :bot
    }
    
    # Filter out anything that is not a Browser or MobileBrowser
    # @return [ActiveRecord::Relation]
    def self.browsers
      self.where("\"#{self.table_name}\".\"agent_class_id\" IN (?)", [0x1000, 0x2000])
    end
    

    def agent_class
      AGENT_CLASSES[agent_class_id]
    end
    
    def agent_class= class_name
      self.agent_class_id = nil
      AGENT_CLASSES.each do |key, value|
        if value == class_name
          self.agent_class_id = key
          break
        end
      end      
    end
    
    # Guess the user agent data from the given request_header attribute and fill out the fields.
    def guess_agent_type    
      return if request_header.blank?
      
      agent_string = request_header.gsub(/[UI];[ ]*/, '')
      
      void, self.os, x11_os, comp_os = agent_string.match(/\(([A-Za-z0-9]*)(?:[^;]*)[; ]*([A-Za-z]*)(?:[^;]*)[; ]*([A-Za-z]*)/).to_a
      
      # if os is only a number it is probably a wrong found
      void, self.os, x11_os, comp_os = agent_string.match(/\).*\(([A-Za-z0-9]*)(?:[^;]*)[; ]*([A-Za-z]*)(?:[^;]*)[; ]*([A-Za-z]*)/).to_a if  os =~ /^[0-9]*$/ 
      
      self.os = comp_os if os == 'compatible'
      self.os = x11_os if %w(Linux).include? os and ['Android'].include? x11_os
			self.os = x11_os if %w(X11 Unknown PDA).include? os and not x11_os.blank?
			self.os = 'Linux' if %w(Arch Gentoo).include? os and agent_string =~ /#{os} Linux/
			self.os = 'Windows CE' if agent_string =~ /Windows CE/ or agent_string =~ /WindowsCE/
      
      if agent_string =~ /Opera[\/ ]/ or agent_string =~ /Opera$/
				self.name = "Opera"
				
				void, self.full_version = agent_string.match(/Version\/([0-9\.]*)/).to_a if agent_string =~ /Version\//			
				void, self.full_version = agent_string.match(/Opera[\/ ]([0-9\.]*)/).to_a if full_version.blank? or full_version =~ /^[0-9]+$/
				
				if agent_string =~ /^[^\(]*\(compatible; MSIE/
				  matches = agent_string.match /\(compatible; MSIE [0-9\.]*; ([a-zA-Z0-9]*)([a-zA-z0-9\ \/\._-]*)(?:; )?([a-zA-Z0-9]*)/
			  				
  				if matches
  				  self.os = matches[1]	
    				self.os = matches[3] if %w(X11 MSIE).include? os
    			end
  			end
  						
			  self.os = "Nintendo Wii" if os=='Nintendo'
  			
  			void, self.full_version = agent_string.match(/Opera ([0-9]+\.[0-9\.]+)/).to_a if full_version.blank?
  			
  			if agent_string =~ /Opera Mobi[;\/]/
  			  self.name = 'Opera Mobile'
  			elsif agent_string =~ /Opera Mini\//
    			self.name = 'Opera Mini'
  			end
  			
  			void, mini_version = agent_string.match(/Opera Mini\/([0-9]+\.[0-9\.]+)/).to_a
  			self.full_version = mini_version unless mini_version.blank?

  			self.agent_class = :browser
  			
  			if ['Opera Mini', 'Opera Mobile'].include? name
  			  self.agent_class = :mobile_browser
  			  
			    if agent_string =~ /BlackBerry/
			      self.os = 'BlackBerry'
			    elsif agent_string =~ /Android/
  			    self.os = 'Android'
  			  elsif agent_string =~ /Series 60/ or agent_string =~ /SymbOS/ or agent_string =~ /SymbianOS/  
  			    self.os = 'Symbian OS'
  			  elsif agent_string =~ /Windows Mobile; WCE;/
  			    self.os = 'Windows CE'
  			  elsif agent_string =~ /Windows Mobile;/ or agent_string =~ /Microsoft Windows;/
  			    self.os = 'Windows Mobile'
  			  elsif os == 'Linux' and agent_string =~ /Maemo/
  			    self.os = 'Maemo'
  			  elsif agent_string =~ /iPhone/ or agent_string =~ /iPad/ or agent_string =~ /iPod/
  			    self.os = 'iOS'
			    end
			  elsif os == 'Symbian'
			    self.name = 'Opera Mobile'
			    self.agent_class = :mobile_browser
			  end
  			
  			if agent_string =~ /Presto\//
  			  void, self.engine_version = agent_string.match(/Presto\/([0-9]+\.[0-9\.]+)/).to_a
  			  self.engine_name = 'Presto'
  			elsif (version = self.full_version.to_f) >= 7.0
  			  self.engine_name = 'Presto'
  			  
  			  if version > 11.6
  			    self.engine_version = nil
  			  elsif version >= 11.5 
  			    self.engine_version = '2.9.168'
  			  elsif version >= 11.1
  			    self.engine_version = '2.8.131'
  			  elsif version >= 11.0
  			    self.engine_version = '2.7.62'
  			  elsif name == 'Opera' 
  			    if version >= 10.6
  			      self.engine_version = '2.6.30'
  			    elsif version >= 10.5
  			      self.engine_version = '2.5.24'
  			    elsif version >= 10.0
  			      self.engine_version = '2.2.15'
  			    elsif version >= 9.6
  			      self.engine_version = '2.1.1'
  			    elsif version >= 9.5
  			      self.engine_version = '2.1'
  			    elsif version >= 9.0
  			      self.engine_version = '2.0'
  			    else
  			      self.engine_version = '1.0'
  			    end
			    elsif name == 'Opera Mobile'
		        if version >= 10.1
		          self.engine_version = '2.5.24'
		        elsif version >= 10
		          self.engine_version = '2.4'
		        elsif version >= 9.8
		          self.engine_version = '2.2.15'
		        elsif version >= 9.7
		          self.engine_version = '2.2'
		        else
		          self.engine_version = '2.1'
		        end
  			  end
 			  end
 			elsif agent_string =~ /AppleWeb[kK]it/			
			  self.name = "WebKit Browser"
			  self.engine_name = 'WebKit'
			  void, self.engine_version = agent_string.match(/AppleWeb[kK]it\/([0-9\.]*)/).to_a
	
			  	
				if agent_string =~ /Mobile/ || agent_string =~ /Android/ || agent_string =~ / Pre\// and not agent_string =~ /Series60\//
					self.name = "Mobile Safari"
					
					void, self.full_version = agent_string.match(/Version\/([0-9\.]*)/).to_a
					
					if ['iPod', 'iPhone', 'iPad'].include? os
						self.os = 'iOS'
					elsif os =~ /webOS/
						self.os='Palm webOS'
					elsif os == 'BlackBerry'
					  self.name = 'BlackBerry Browser'
					end
					
					if agent_string =~ /Dorothy/
					  self.name = 'Dorothy'	  
  					self.os = 'Windows CE' if os == 'Windows'
					end					
					
					self.agent_class = :mobile_browser
			  elsif agent_string =~ /ABrowse/
  		    self.name = "ABrowse"	
  				void, self.full_version = agent_string.match(/ABrowse ([0-9\.]*)/).to_a
  				self.agent_class = :browser
  			elsif agent_string =~ /[Ee]piphany/
  				self.name = "Epiphany"
  				void, self.full_version = agent_string.match(/Epiphany\/([0-9\.]*)/).to_a
  				self.agent_class = :browser
  			elsif agent_string =~ /OmniWeb/
  				self.name = "OmniWeb"
  				void, self.full_version = agent_string.match(/OmniWeb\/v([0-9\.]*)/).to_a
  				self.os = 'OS X'
  				self.agent_class = :browser  				
				else	
				  chrome_aliases = %w(Chromium Iron)
				  webkit_browsers = ['QtWeb Internet Browser'] + %w(Arora Flock Fluid Hana RealPlayer Shiira Stainless SunriseBrowser Sunrise Skyfire TeaShark BOLT Series60 webOS Chrome) + chrome_aliases
				  
          self.agent_class = :browser
				  
				  webkit_browsers.each do |agent|
            if agent_string =~ /#{agent}/
              if chrome_aliases.include?(agent)
                self.name = 'Chrome'
              else
    				    self.name = agent
    				  end
    				  void, self.full_version = agent_string.match(/#{agent}\/([0-9\.]*)/).to_a
    				  void, self.full_version = agent_string.match(/Version\/([0-9\.]*)/).to_a if full_version.blank?
    				  break
            end
          end
        end	
        
        self.name = 'Sunrise' if name == 'SunriseBrowser'
        self.name = 'Bolt' if name == 'BOLT'
        if name == 'Series60' or os == 'SymbianOS'
          self.name = 'Browser for S60' 
          self.agent_class = :mobile_browser
        end
        
        if name == 'webOS'
          self.name = 'webOS Browser' 
          self.agent_class = :mobile_browser
        end
        
        if %w(Skyfire).include? self.name
          self.os = 'Android'
          self.agent_class = :mobile_browser
        elsif %w(TeaShark Bolt).include? self.name
          self.os = 'J2ME'
          self.agent_class = :mobile_browser
        end
					
				if agent_string =~ /Safari/ and self.name == "WebKit Browser"
					self.name = "Safari"
					
					void, self.full_version = agent_string.match(/Version\/([0-9\.]*)/).to_a
					
					unless self.full_version
					  void, webkit_version = agent_string.match(/Safari\/([0-9\.]*)/).to_a
						
						self.full_version = case webkit_version 
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
  			  self.name = "Konqueror"	
  			  void, self.full_version = agent_string.match(/Konqueror[\/ ]([0-9\.]*)/).to_a
        	void, self.os = agent_string.match(/Konqueror[^;]*; (?:i[36]86 )?([A-Za-z0-9]*)/).to_a
        	self.os = nil if os == 'X11'
        	self.engine_name = 'KHTML'
        	void, self.engine_version = agent_string.match(/KHTML[\/ ]([0-9\.]*)/).to_a
        	self.engine_version = full_version if engine_version.blank?
        	self.agent_class = :browser
		  
				      
			elsif agent_string =~ /Gecko/
				self.name = "Gecko Browser";
				
				real_agent = nil
				self.agent_class = :browser
				
				firefox_aliases = %w(Firebird Minefield BonEcho Iceweasel Shiretoko GranParadiso IceCat Iceweasel IceWeasel Namoroka Phoenix)
				gecko_browsers = %w(BeZillaBrowser Beonex Camino Chimera Conkeror Epiphany Flock Galeon Iceape K-Meleon K-Ninja Kapiko Kazehakase KMLite MultiZilla SeaMonkey Netscape Navigator Prism Fennec Minimo Firefox) + firefox_aliases
				
				agent_string = agent_string.gsub('prism', 'Prism')
				
				gecko_browsers.each do |agent|
				  if agent_string =~ /#{agent}/
				    self.name = agent
    				break
    			end
			  end
			  
			  self.engine_name = 'Gecko'
			  void, self.engine_version = agent_string.match(/rv:([0-9\.]*)/).to_a

	      if self.name == "Gecko Browser"   
	        self.full_version = engine_version
	      else
	        void, self.full_version = agent_string.match(/#{self.name}\/([0-9\.]*)/).to_a
        end
        
        self.name = 'Netscape Navigator' if %w(Netscape Navigator).include? name
        self.name = 'Firefox' if firefox_aliases.include? name
  			
				if agent_string =~ /Maemo Browser[\/ ][0-9]/
				  self.name = 'Maemo Browser'
				  void, self.full_version = agent_string.match(/Maemo Browser[\/ ]([0-9\.]*)/).to_a
			    self.os = 'Maemo'
			    self.agent_class = :mobile_browser
			  end
			  
			  if %w(Fennec Minimo).include? name
			    self.agent_class = :mobile_browser
		    end  
 			
 			elsif agent_string =~ /Series60\//
				self.name = 'Browser for S60'
				self.os = 'Symbian OS'
				void, self.full_version = agent_string.match(/Series60\/([0-9\.]*)/).to_a
				self.agent_class = :mobile_browser
			elsif agent_string =~ /Series80\//
				self.name = 'Browser for S80'
				self.os = 'Symbian OS'
				void, self.full_version = agent_string.match(/Series80\/([0-9\.]*)/).to_a
				self.agent_class = :mobile_browser
			
      elsif agent_string =~ /compatible; MSIE/
				self.name = "Internet Explorer"
				
				void, self.full_version, self.os = agent_string.match(/MSIE ([0-9\.]*)(?:b[0-9]*)?; ([A-Za-z]*)/).to_a
				
				if os=='Mac'
					self.os = 'Macintosh'
				elsif os != 'Windows' and agent_string =~ /Windows/
				  self.os = 'Windows'
				end
				self.agent_class = :browser
				
				if agent_string =~ /IEMobile[\/ ][0-9]/
			    self.name = 'IE Mobile'
			    self.agent_class = :mobile_browser
			    void, self.full_version= agent_string.match(/IEMobile[\/ ]([0-9\.]*)/).to_a
			    void, self.os = agent_string.match(/(Windows [A-Za-z0-9]*)/).to_a
			  end
				
				if agent_string =~ /Trident\//
  			  void, self.engine_version = agent_string.match(/Trident\/([0-9]+\.[0-9\.]+)/).to_a
  			  self.engine_name = 'Trident'
				elsif (version = self.full_version.to_f) >= 4
				  logger.debug "#{self.full_version}: #{version}"
				  self.engine_name = 'Trident'
				  if version > 10.0
				    self.engine_version = nil
				  elsif version >= 10.0
				    self.engine_version = '6.0'
				  elsif version >= 9.0
				    self.engine_version = '5.0'
				  elsif version >= 8.0
				    self.engine_version = '4.0'
				  elsif version >= 7.0
				    self.engine_version = '3.1'
				  elsif version >= 6.0
				    self.engine_version = '3.0'
				  elsif version >= 5.5
				    self.engine_version = '2.2'
				  elsif version >= 5.1
				    self.engine_version = '2.1'
				  elsif version >= 5.0
				    self.engine_version = '2.0'
			    else
			      self.engine_version = '1.0'
		      end
		      
		      if agent_string =~ /Windows CE;/ and agent_string =~ /[pP]rofile\/MIDP/
		        self.name = 'IE Mobile'
  			    self.os = 'Windows CE'
  			    self.agent_class = :mobile_browser
			    end
				  
			  end
				
				if agent_string =~ /Avant Browser/
				  self.name = 'Avant Browser'
				  self.full_version = nil
				elsif agent_string =~ /PalmSource[^;]*; Blazer/
				  self.name = 'Blazer'
				  void, self.full_version = agent_string.match(/Blazer[\/ ]([0-9\.]*)/).to_a
				  self.engine_name = nil
				  self.engine_version = nil
			    self.os = 'Palm OS'
			    self.agent_class = :mobile_browser
				elsif agent_string =~ /EudoraWeb/
				  self.name = 'EudoraWeb'
				  void, self.full_version = agent_string.match(/EudoraWeb ([0-9\.]*)/).to_a
				  self.engine_name = nil
				  self.engine_version = nil
				  self.agent_class = :mobile_browser
			  elsif agent_string =~ /uZard(?:Web)?[\/ ][0-9]/
			    self.name = 'uZard'
			    void, self.full_version= agent_string.match(/uZard(?:Web)?[\/ ]([0-9\.]*)/).to_a
			    self.os = nil
			    self.agent_class = :mobile_browser
			  end

				
			# Rare Browsers
						
			elsif agent_string =~ /ABrowse/
			  # Old version of ABrowse don't include AppleWebKit in agent_string
		    self.name = "ABrowse"	
				void, self.full_version, self.os = agent_string.match(/ABrowse ([0-9\.]*)(?:[a-zA-z0-9\ \/\._-]*); ([a-zA-Z0-9]*)/).to_a
				self.agent_class = :browser
			elsif agent_string =~ /amaya\//
				self.name = "Amaya"
				void, self.full_version = agent_string.match(/amaya\/([0-9\.]*)/).to_a
				self.agent_class = :browser  			
			elsif agent_string =~ /AmigaVoyager/
			  self.name = "AmigaVoyager"	
			  self.os = "AmigaOS"
      	void, self.full_version = agent_string.match(/AmigaVoyager\/([0-9\.]*)/).to_a
      	self.agent_class = :browser    
			elsif agent_string =~ /^Avant Browser/
			  self.name = "Avant Browser"	
			  self.os = 'Windows'
      	void, self.full_version = agent_string.match(/Avant Browser\/([0-9\.]*)/).to_a
      	self.agent_class = :browser          	
			elsif agent_string =~ /\(Charon;/
			  self.name = "Charon"	
				void, self.os = agent_string.match(/\(Charon; (.*)\)/).to_a
				self.agent_class = :browser
			elsif agent_string =~ /Cyberdog/
			  self.name = "Cyberdog"	
			  self.os = "Classic Macintosh"
      	void, self.full_version = agent_string.match(/Cyberdog\/([0-9\.]*)/).to_a
      	self.agent_class = :browser
      elsif agent_string =~ /Dillo\//
				self.name = "Dillo"
				void, self.full_version = agent_string.match(/Dillo\/([0-9\.]*)/).to_a
				self.agent_class = :browser
      elsif agent_string =~ /E[lL]inks/
			  self.name = "ELinks"	
			  void, self.os = agent_string.match(/;\s?([A-Za-z0-9]*)(?:[\+a-zA-z0-9\s\/\._-]*);\s?[0-9]+x[0-9]+/).to_a
      	void, self.full_version = agent_string.match(/E[lL]inks\/([0-9\.]*)/).to_a
      	void, self.full_version = agent_string.match(/E[lL]inks \(([0-9\.]*)/).to_a if full_version.blank?
      	self.agent_class = :browser	
      elsif agent_string =~ /Galaxy/
			  self.name = "Galaxy"	
			  void, self.os = agent_string.match(/\(([A-Za-z0-9]*)/).to_a
      	void, self.full_version = agent_string.match(/Galaxy[\/ ]([0-9\.]*)/).to_a
      	self.agent_class = :browser	
      elsif agent_string =~ /HotJava/
			  self.name = "HotJava"	
      	void, self.full_version = agent_string.match(/HotJava[\/ ]([0-9\.]*)/).to_a
      	self.agent_class = :browser	
      elsif agent_string =~ /IBM WebExplorer/
			  self.name = "IBM WebExplorer"	
			  self.os = 'OS/2'
      	void, self.full_version = agent_string.match(/\/v([0-9\.]*)/).to_a
      	self.agent_class = :browser	
      elsif agent_string =~ /IBrowse/
			  self.name = "IBrowse"	
			  self.os = 'AmigaOS'
      	void, self.full_version = agent_string.match(/IBrowse[\/ ]([0-9\.]*)/).to_a
      	self.agent_class = :browser	
      elsif agent_string =~ /iCab/
			  self.name = "iCab"	
			  self.os = 'OS X'
      	void, self.full_version = agent_string.match(/iCab[\/ ]([0-9\.]*)/).to_a
      	self.agent_class = :browser	
      elsif agent_string =~ /^Links/
				self.name = "Links"
				void, self.full_version = agent_string.match(/Links (?:\()?([0-9\.]*)/).to_a
				void, self.os = agent_string.match(/Links[^;]*; ([A-Za-z0-9]*)/).to_a
				self.os = nil if os == 'Unix'
				self.os = 'Macintosh' if os == 'Darwin'
				self.agent_class = :browser
      elsif agent_string =~ /^Lynx/
				self.name = "Lynx"
				self.os = nil
				void, self.full_version = agent_string.match(/Lynx\/([0-9\.]*)/).to_a
				self.agent_class = :browser
			elsif agent_string =~ /Midori\/[0-9]/
			  self.name = "Midori"
			  void, self.full_version = agent_string.match(/Midori\/([0-9\.]*)/).to_a
			  self.engine_name = 'WebKit'
			  void, self.engine_version = agent_string.match(/WebKit\/\(([0-9\.]*)/).to_a
			  self.agent_class = :browser
			elsif agent_string =~ /^NCSA[_ ]Mosaic\//
			  self.name = "Mosaic"
				void, self.full_version = agent_string.match(/Mosaic\/([0-9\.]*)/).to_a
				void, self.os = agent_string.match(/\((?:X11;[ ]?)?([A-Za-z0-9]*)/).to_a
				self.os = nil if os == 'Unix'
				self.os = 'Macintosh' if os == 'Darwin'
				self.agent_class = :browser
			elsif agent_string =~ /neon\//
				self.name = "Neon"
				void, self.full_version = agent_string.match(/neon\/([0-9\.]*)/).to_a
				self.agent_class = :browser
			elsif agent_string =~ /NetPositive\//
				self.name = "NetPositive"
				void, self.full_version = agent_string.match(/NetPositive\/([0-9\.]*)/).to_a
				self.agent_class = :browser				
			elsif agent_string =~ /NetSurf\//
				self.name = "NetSurf"
				void, self.full_version = agent_string.match(/NetSurf\/([0-9\.]*)/).to_a
				self.agent_class = :browser
			elsif agent_string =~ /OmniWeb\//
				self.name = "OmniWeb"
				void, self.full_version = agent_string.match(/OmniWeb\/([0-9\.]*)/).to_a
				self.os = 'OS X'
				self.agent_class = :browser
			elsif agent_string =~ /^w3m[\/ ]?/
			  self.name = 'w3m'
			  void, self.full_version = agent_string.match(/w3m[\/ ]([0-9\.]*)/).to_a
			  self.full_version = '0.5.2' if full_version == '0.52'
			  void, self.os = agent_string.match(/\(([A-Za-z0-9]*)/).to_a
			  self.os = 'Linux' if os == 'Debian'
			  self.agent_class = :browser
			elsif agent_string == 'WorldWideweb (NEXT)'
			  self.name = 'WorldWideweb'
			  self.os = 'NeXT OS'
			  self.agent_class = :browser
			elsif agent_string =~ /Yandex\//
				self.name = "Yandex"
				void, self.full_version = agent_string.match(/Yandex\/([0-9\.]*)/).to_a
				self.os = 'Windows'
				self.agent_class = :browser
				
			# Console Browsers	
				
			elsif agent_string =~ /Bunjalloo\//
			  self.name = "Bunjalloo"
				void, self.full_version = agent_string.match(/Bunjalloo\/([0-9\.]*)/).to_a
				void, self.os = agent_string.match(/\(([A-Za-z0-9 ]*)/).to_a
				self.agent_class = :browser
			elsif agent_string =~ /\(PLAYSTATION 3/
			  self.name = "Playstation 3"
				void, self.full_version = agent_string.match(/PLAYSTATION 3; ([0-9\.]*)/).to_a
				self.os = "Playstation 3"
				self.agent_class = :browser
			elsif agent_string =~ /\(PS3 \(PlayStation 3\)/
			  self.name = "Playstation 3"
				void, self.full_version = agent_string.match(/\(PS3 \(PlayStation 3\); ([0-9\.]*)/).to_a
				self.os = "Playstation 3"
				self.agent_class = :browser
			elsif agent_string =~ /PSP \(PlayStation Portable\)/
			  self.name = "PlayStation Portable"
				void, self.full_version = agent_string.match(/PSP \(PlayStation Portable\); ([0-9\.]*)/).to_a
				self.os = "PlayStation Portable"
				self.agent_class = :browser
			elsif agent_string =~ /wii libnup/
			  self.name = "Wii Browser"
				void, self.full_version = agent_string.match(/wii libnup\/([0-9\.]*)/).to_a
				self.os = "Nintendo Wii"
				self.agent_class = :browser
				
			# Mobile Browsers
				
			elsif agent_string =~ /^BlackBerry/
			  self.name = "BlackBerry Browser"
				void, self.full_version = agent_string.match(/^BlackBerry[0-9]*[i]*\/([0-9\.]*)/).to_a
				self.os = "BlackBerry"
				self.agent_class = :mobile_browser		
			elsif agent_string =~ /portalmmm\//
  			self.name = "IMode mobile browser"
  			void, self.full_version = agent_string.match(/portalmmm\/([0-9\.]*)/).to_a
  			self.os = nil
  			self.agent_class = :mobile_browser
			elsif agent_string =~ /^Doris/
			  self.name = "Doris"
				void, self.full_version = agent_string.match(/^Doris\/([0-9\.]*)/).to_a
				self.os = "SymbianOS"
				self.agent_class = :mobile_browser
			elsif agent_string =~ /\/GoBrowser/
			  self.name = "GoBrowser"
				void, self.full_version = agent_string.match(/\/GoBrowser\/([0-9\.]*)/).to_a
				void, self.os = agent_string.match(/\(([A-Za-z0-9]*)/).to_a
				self.agent_class = :mobile_browser
			elsif agent_string =~ /MIB\/[0-9]/
			  self.name = "Motorola Internet Browser"
				void, self.full_version = agent_string.match(/MIB\/([0-9\.]*)/).to_a
				self.os = 'J2ME'
				self.agent_class = :mobile_browser
			elsif agent_string =~ /UP.Browser\//
			  self.name = "UP Browser"
				void, self.full_version = agent_string.match(/UP.Browser\/([0-9\.]*)/).to_a
				self.os = 'J2ME'
				self.agent_class = :mobile_browser
			elsif agent_string =~ /NetFront\/[0-9]/
			  self.name = "NetFront"
				void, self.full_version = agent_string.match(/NetFront\/([0-9\.]*)/).to_a
				self.os = 'Kindle' if agent_string =~ /Kindle\/[0-9]/
				self.agent_class = :mobile_browser
			elsif agent_string =~ /POLARIS\/[0-9]/
			  self.name = "Polaris"
				void, self.full_version = agent_string.match(/POLARIS\/([0-9\.]*)/).to_a
				self.agent_class = :mobile_browser
			elsif agent_string =~ /SEMC-Browser\//
				self.name = "SonyEricsson Browser"
				self.os = 'J2ME'
				void, self.full_version = agent_string.match(/SEMC-Browser\/([0-9\.]*)/).to_a
				self.agent_class = :mobile_browser
			elsif agent_string =~ /Teleca/
			  self.name = "Teleca-Obigo"
  			void, self.full_version, self.os = agent_string.match(/Teleca[\/ ]([A-Z0-9\.]*)(?:; )?([A-Za-z0-9]*)/).to_a
  			self.agent_class = :mobile_browser
			  
  		elsif agent_string =~ /^SonyEricsson/
  		  self.name = "SonyEricsson Browser"
			  self.os = 'J2ME'
			  self.agent_class = :mobile_browser
			elsif agent_string =~ /[pP]rofile\/MIDP-/
			  self.name = "MIDP Browser"
			  self.os = 'J2ME'
  			void, self.full_version = agent_string.match(/[pP]rofile\/MIDP-([A-Za-z0-9\.]*)/).to_a
  			self.agent_class = :mobile_browser
			  
			# Known Bots									
			elsif agent_string =~ /Yahoo! Slurp/
				self.name = "Yahoo! Bot"
				self.agent_class = :bot										
			elsif agent_string =~ /Googlebot/ || agent_string =~ /Google-Sitemaps/
				self.name = "Google Bot"
				self.agent_class = :bot										
			elsif agent_string =~ /ia_archiver/
				self.name = "Internet Archive Bot"
				self.agent_class = :bot										
			elsif agent_string =~ /msnbot/
				self.name = "MSN Live Search Bot"
				self.agent_class = :bot										
			elsif agent_string =~ /ScoutJet/
				self.name = "ScoutJet Bot"
				self.agent_class = :bot										
			elsif agent_string =~ /Ask Jeeves/
				self.name = "Ask Jeeves Bot"
				self.agent_class = :bot										
			elsif agent_string =~ /AboutUsBot/
				self.name = "AboutUsBot"
				self.agent_class = :bot										
			elsif agent_string =~ /NaverBot/
				self.name = "NaverBot"
				self.agent_class = :bot										
			elsif agent_string =~ /Gigabot/
				self.name = "Gigabot"
				self.agent_class = :bot										
			elsif agent_string =~ /CyberPatrol SiteCat/
				self.name = "CyberPatrol Bot"
				self.agent_class = :bot										
			elsif agent_string =~ /BLT/
				self.name = "BLT"
				self.agent_class = :bot										
			elsif agent_string =~ /Netluchs/
				self.name = "Netluchs"
				self.agent_class = :bot										
			elsif agent_string =~ /blackspider/
				self.name = "Blackspider"
				self.agent_class = :bot						
			elsif agent_string =~ /Yanga WorldSearch Bot/
				self.name = "Yanga WorldSearch Bot"
				void, self.full_version = agent_string.match(/v([0-9\.]*)/).to_a
				self.agent_class = :bot				
			elsif agent_string=~ /Twiceler/
				self.name = "Twiceler"
				void, self.full_version = agent_string.match(/Twiceler-([0-9\.]*)/).to_a
				self.agent_class = :bot				
			elsif agent_string =~ /WebDataCentreBot/
				self.name = "WebDataCentreBot"
				void, self.full_version = agent_string.match(/WebDataCentreBot\/([0-9\.]*)/).to_a
				self.agent_class = :bot			
			elsif agent_string =~ /DomainCrawler/
				self.name = "DomainCrawler"
				void, self.full_version = agent_string.match(/DomainCrawler\/([0-9\.]*)/).to_a
				self.agent_class = :bot			
			elsif agent_string =~ /NetcraftSurveyAgent/
				self.name = "NetcraftSurveyAgent"
				void, self.full_version = agent_string.match(/NetcraftSurveyAgent\/([0-9\.]*)/).to_a
				self.agent_class = :bot			
			elsif agent_string =~ /Snapbot/	
				self.name = "Snapbot"
				void, self.full_version = agent_string.match(/Snapbot\/([0-9\.]*)/).to_a
				self.agent_class = :bot			
			elsif agent_string =~ /Jyxobot/
				self.name = "Jyxobot"
				void, self.full_version = agent_string.match(/Jyxobot\/([0-9\.]*)/).to_a
				self.agent_class = :bot			
			elsif agent_string =~ /Speedy Spider/
				self.name = "Speedy Spider"
				self.agent_class = :bot			
			elsif agent_string =~ /iPhoto/
				self.name = "iPhoto"
				void, self.full_version, self.os = agent_string.match(/iPhoto\/([0-9\.]*) \(([A-Za-z1-9]*);/).to_a
				self.agent_class = :browser							
			elsif agent_string =~ /mylinkcheck/
				self.name = "MyLinkCheck"
				void, self.full_version = agent_string.match(/mylinkcheck\/([0-9\.]*)/).to_a
				self.agent_class = :bot				
			elsif agent_string =~ /W3C-checklink/
				self.name = "W3C-checklink"
				void, self.full_version = agent_string.match(/W3C-checklink\/([0-9\.]*)/).to_a
				self.agent_class = :bot				
			elsif agent_string =~ /Eurobot/
				self.name = "Eurobot"
				void, self.full_version = agent_string.match(/Eurobot\/([0-9\.]*)/).to_a
				self.agent_class = :bot				
			elsif agent_string =~ /JoeDog\//
				self.name = "JoeDog"
				void, self.full_version = agent_string.match(/JoeDog\/([0-9\.]*)/).to_a
				self.agent_class = :bot
			elsif agent_string =~ /W3C_Validator\//
				self.name = "W3C_Validator"
				void, self.full_version = agent_string.match(/W3C_Validator\/([0-9\.]*)/).to_a
				self.agent_class = :bot
			elsif agent_string =~ /Wget\//
				self.name = "Wget"
				void, self.full_version = agent_string.match(/Wget\/([0-9\.]*)/).to_a
				self.agent_class = :bot
			
			elsif agent_string =~ /WebAlta Crawler\//
				self.name = "WebAlta Crawler"
				void, self.full_version = agent_string.match(/WebAlta Crawler\/([0-9\.]*)/).to_a
				self.agent_class = :bot
			elsif agent_string =~ /WebAlta Crawler\//
				self.name = "WebAlta Crawler"
				void, self.full_version = agent_string.match(/WebAlta Crawler\/([0-9\.]*)/).to_a
				self.agent_class = :bot
			elsif agent_string =~ /WWW-Mechanize\//
				self.name = "WWW-Mechanize";
				void, self.full_version = agent_string.match(/WWW-Mechanize\/([0-9\.]*)/).to_a
				self.agent_class = :bot
			elsif agent_string =~ /Serverstress Analysis Software/
				self.name = 'Serverstress Analysis Software'
				self.agent_class = :bot

			elsif agent_string =~ /Java\//
				self.name = 'Java Client';
				self.os = nil
				void, self.full_version = agent_string.match(/Java\/([0-9\.]*)/).to_a
				self.agent_class = :bot
			elsif agent_string.strip == 'http://www.uni-koblenz.de/~flocke/robot-info.txt'
				self.name = 'http://www.uni-koblenz.de/~flocke/robot-info.txt'
				self.agent_class = :bot
			elsif agent_string =~ /^Shelob/
				self.name = 'Shelob';
				self.agent_class = :bot
			end
		
			# Cleanup
			
			self.full_version = "#{full_version}0" if full_version =~ /^[0-9]+\.$/
			self.full_version = "#{full_version}.0" if full_version =~ /^[0-9]+$/
			self.os = 'OS X' if ['Macintosh', 'Mac'].include? os
			self.os = 'Windows' if os == 'Win'
			self.os = 'Symbian OS' if %w(Symbian SymbianOS).include? os 
			self.os = 'J2ME' if os == 'J2ME/MIDP'
			self.os = 'Brew' if os == 'BREW'
			
			self.full_version = nil if self.full_version.blank?
			self.full_version.sub!(/\.$/,'') if self.full_version 
			self.major_version = full_version.match(/^([0-9]*\.[0-9]*)/).to_a.last if full_version
			self.major_version = full_version if major_version.blank?
    end
  end
end