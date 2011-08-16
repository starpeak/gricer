module Gricer
  # ActiveRecord Model for Session Statistics
  # @attr [Gricer::Session] previous_session
  #   The current value of the associated previous session.
  #
  # @attr [Gricer::Agent] agent
  #   The current value of the associated agent.
  #
  # @attr [String] ip_address_hash
  #   The current value of the ip address in an anonyminized hash
  #
  # @attr [String] domain
  #   The current value of the domain (only major info) from which the session was requested.
  #
  # @attr [String] country
  #   The current value of the country from which the session was requested.
  #
  #   You need to configure a GeoIP in the {Gricer::Config} instance.
  #
  # @attr [String] region
  #   The current value of the region from which the session was requested.
  #
  #   You need to configure a GeoIP in the {Gricer::Config} instance.
  #
  # @attr [String] city
  #   The current value of the city from which the session was requested.
  #
  #   You need to configure a GeoIP in the {Gricer::Config} instance.
  #
  # @attr [String] postal_code
  #   The current value of the region from which the session was requested.
  #
  #   You need to configure a GeoIP in the {Gricer::Config} instance.
  #
  # @attr [Float] longitude
  #   The current value of the longitude of the city/region from which the session was requested.
  #
  #   You need to configure a GeoIP in the {Gricer::Config} instance.
  #
  # @attr [Float] latitude
  #   The current value of the latitude of the city/region from which the session was requested.
  #
  #   You need to configure a GeoIP in the {Gricer::Config} instance.
  #
  # @attr [Boolean] javascript
  #   The current value of the javascript capability of the requesting agent.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [Boolean] java
  #   The current value of the java capability of the requesting agent.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [String] flash_version
  #   The current value of the version of flash installed on the requesting agent.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [String] flash_major_version
  #   The current value of the major version of flash installed on the requesting agent.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [String] silverlight_version
  #   The current value of the version of silverlight installed on the requesting agent.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [String] silverlight_major_version
  #   The current value of the major version of silverlight installed on the requesting agent.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [Integer] screen_width
  #   The current value of the width in pixels of the screen the requesting agent's window is on.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [Integer] screen_height
  #   The current value of the height in pixels of the screen the requesting agent's window is on.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [Integer] screen_depth
  #   The current value of the depth in bits of the screen the requesting agent's window is on.
  #
  #   This feature needs the usage of {Gricer::TrackHelper#gricer_track_tag}.
  #
  # @attr [String] requested_locale_major
  #   The current value of the locale requested (major locale only)
  #
  # @attr [String] requested_locale_minor
  #   The current value of the locale requested (major locale only)
  #
  # @attr [String] requested_locale
  #   The current value of the locale requested 
  #
  class Session < ::ActiveRecord::Base
    set_table_name "#{::Gricer::config.table_name_prefix}sessions"
    include ActiveModel::Statistics
    
    has_many :requests, class_name: 'Gricer::Request', foreign_key: :session_id, order: 'created_at ASC'
    belongs_to :agent, class_name: 'Gricer::Agent', foreign_key: :agent_id, counter_cache: true
    belongs_to :previous_session, class_name: 'Gricer::Session', foreign_key: :previous_session_id
    
    # Filter out anything that is not a Browser or MobileBrowser
    # @return [ActiveRecord::Relation]
    def self.browsers
      self.includes("agent")
      .where("\"#{Agent.table_name}\".\"agent_class_id\" IN (?)", [0x1000, 0x2000])
    end
    
    # Filter out only bounce sessions (sessions with just one request)
    # @return [ActiveRecord::Relation]
    def self.bounce_sessions
      self.where("\"#{self.table_name}\".\"requests_count\" = ?", 1)
    end
    
    # Filter out only new visits (which does not have a previous_session)
    # @return [ActiveRecord::Relation]
    def self.new_visits
      where("\"#{self.table_name}\".\"previous_session_id\" IS NULL")
    end
    
    # This is just a list of two-part domain endings. 
    # It is used to get the domain from the request.
    # return [Array]
    def two_part_domain_endings
      [
        'com.ac','edu.ac','gov.ac','net.ac','mil.ac',
  			'org.ac','com.ae','net.ae','org.ae','gov.ae','ac.ae',
  			'co.ae','sch.ae','pro.ae','com.ai','org.ai','edu.ai',
  			'gov.ai','com.ar','net.ar','org.ar','gov.ar','mil.ar',
  			'edu.ar','int.ar','co.at','ac.at','or.at','gv.at','priv.at',
  			'com.au','gov.au','org.au','edu.au','id.au','oz.au',
  			'info.au','net.au','asn.au','csiro.au','telememo.au',
  			'conf.au','otc.au','com.az','net.az','org.az','com.bb',
  			'net.bb','org.bb','ac.be','belgie.be','dns.be','fgov.be',
  			'com.bh','gov.bh','net.bh','edu.bh','org.bh','com.bm',
  			'edu.bm','gov.bm','org.bm','net.bm','adm.br','adv.br',
  			'agr.br','am.br','arq.br','art.br','ato.br','bio.br',
  			'bmd.br','cim.br','cng.br','cnt.br','com.br','coop.br',
  			'ecn.br','edu.br','eng.br','esp.br','etc.br','eti.br',
  			'far.br','fm.br','fnd.br','fot.br','fst.br','g12.br',
  			'ggf.br','gov.br','imb.br','ind.br','inf.br','jor.br',
  			'lel.br','mat.br','med.br','mil.br','mus.br','net.br',
  			'nom.br','not.br','ntr.br','odo.br','org.br','ppg.br',
  			'pro.br','psc.br','psi.br','qsl.br','rec.br','slg.br',
  			'srv.br','tmp.br','trd.br','tur.br','tv.br','vet.br',
  			'zlg.br','com.bs','net.bs','org.bs','ab.ca','bc.ca',
  			'mb.ca','nb.ca','nf.ca','nl.ca','ns.ca','nt.ca','nu.ca',
  			'on.ca','pe.ca','qc.ca','sk.ca','yk.ca','gc.ca','co.ck',
  			'net.ck','org.ck','edu.ck','gov.ck','com.cn','edu.cn',
  			'gov.cn','net.cn','org.cn','ac.cn','ah.cn','bj.cn','cq.cn',
  			'gd.cn','gs.cn','gx.cn','gz.cn','hb.cn','he.cn','hi.cn',
  			'hk.cn','hl.cn','hn.cn','jl.cn','js.cn','ln.cn','mo.cn',
  			'nm.cn','nx.cn','qh.cn','sc.cn','sn.cn','sh.cn','sx.cn',
  			'tj.cn','tw.cn','xj.cn','xz.cn','yn.cn','zj.cn','arts.co',
  			'com.co','edu.co','firm.co','gov.co','info.co','int.co',
  			'nom.co','mil.co','org.co','rec.co','store.co','web.co',
  			'ac.cr','co.cr','ed.cr','fi.cr','go.cr','or.cr','sa.cr',
  			'com.cu','net.cu','org.cu','ac.cy','com.cy','gov.cy',
  			'net.cy','org.cy','co.dk','art.do','com.do','edu.do',
  			'gov.do','gob.do','org.do','mil.do','net.do','sld.do',
  			'web.do','com.dz','org.dz','net.dz','gov.dz','edu.dz',
  			'ass.dz','pol.dz','art.dz','com.ec','k12.ec','edu.ec',
  			'fin.ec','med.ec','gov.ec','mil.ec','org.ec','net.ec',
  			'com.ee','pri.ee','fie.ee','org.ee','med.ee','com.eg',
  			'edu.eg','eun.eg','gov.eg','net.eg','org.eg','sci.eg',
  			'com.er','net.er','org.er','edu.er','mil.er','gov.er',
  			'ind.er','com.es','org.es','gob.es','edu.es','nom.es',
  			'com.et','gov.et','org.et','edu.et','net.et','biz.et',
  			'name.et','info.et','ac.fj','com.fj','gov.fj','id.fj',
  			'org.fj','school.fj','com.fk','ac.fk','gov.fk','net.fk',
  			'nom.fk','org.fk','asso.fr','nom.fr','barreau.fr',
  			'com.fr','prd.fr','presse.fr','tm.fr','aeroport.fr',
  			'assedic.fr','avocat.fr','avoues.fr','cci.fr',
  			'chambagri.fr','chirurgiens-dentistes.fr',
  			'experts-comptables.fr','geometre-expert.fr',
  			'gouv.fr','greta.fr','huissier-justice.fr','medecin.fr',
  			'notaires.fr','pharmacien.fr','port.fr','veterinaire.fr',
  			'com.ge','edu.ge','gov.ge','mil.ge','net.ge','org.ge',
  			'pvt.ge','co.gg','org.gg','sch.gg','ac.gg','gov.gg',
  			'ltd.gg','ind.gg','net.gg','alderney.gg','guernsey.gg',
  			'sark.gg','com.gt','edu.gt','net.gt','gob.gt','org.gt',
  			'mil.gt','ind.gt','com.gu','edu.gu','net.gu','org.gu',
  			'gov.gu','mil.gu','com.hk','net.hk','org.hk','idv.hk',
  			'gov.hk','edu.hk','co.hu','2000.hu','erotika.hu',
  			'jogasz.hu','sex.hu','video.hu','info.hu','agrar.hu',
  			'film.hu','konyvelo.hu','shop.hu','org.hu','bolt.hu',
  			'forum.hu','lakas.hu','suli.hu','priv.hu','casino.hu',
  			'games.hu','media.hu','szex.hu','sport.hu','city.hu',
  			'hotel.hu','news.hu','tozsde.hu','tm.hu','erotica.hu',
  			'ingatlan.hu','reklam.hu','utazas.hu','ac.id','co.id',
  			'go.id','mil.id','net.id','or.id','co.il','net.il',
  			'org.il','ac.il','gov.il','k12.il','muni.il','idf.il',
  			'co.im','net.im','org.im','ac.im','lkd.co.im','gov.im',
  			'nic.im','plc.co.im','co.in','net.in','ac.in','ernet.in',
  			'gov.in','nic.in','res.in','gen.in','firm.in','mil.in',
  			'org.in','ind.in','ac.je','co.je','net.je','org.je',
  			'gov.je','ind.je','jersey.je','ltd.je','sch.je','com.jo',
  			'org.jo','net.jo','gov.jo','edu.jo','mil.jo','ad.jp',
  			'ac.jp','co.jp','go.jp','or.jp','ne.jp','gr.jp','ed.jp',
  			'lg.jp','net.jp','org.jp','gov.jp','hokkaido.jp',
  			'aomori.jp','iwate.jp','miyagi.jp','akita.jp',
  			'yamagata.jp','fukushima.jp','ibaraki.jp','tochigi.jp',
  			'gunma.jp','saitama.jp','chiba.jp','tokyo.jp',
  			'kanagawa.jp','niigata.jp','toyama.jp','ishikawa.jp',
  			'fukui.jp','yamanashi.jp','nagano.jp','gifu.jp',
  			'shizuoka.jp','aichi.jp','mie.jp','shiga.jp','kyoto.jp',
  			'osaka.jp','hyogo.jp','nara.jp','wakayama.jp','tottori.jp',
  			'shimane.jp','okayama.jp','hiroshima.jp','yamaguchi.jp',
  			'tokushima.jp','kagawa.jp','ehime.jp','kochi.jp',
  			'fukuoka.jp','saga.jp','nagasaki.jp','kumamoto.jp',
  			'oita.jp','miyazaki.jp','kagoshima.jp','okinawa.jp',
  			'sapporo.jp','sendai.jp','yokohama.jp','kawasaki.jp',
  			'nagoya.jp','kobe.jp','kitakyushu.jp','utsunomiya.jp',
  			'kanazawa.jp','takamatsu.jp','matsuyama.jp','com.kh',
  			'net.kh','org.kh','per.kh','edu.kh','gov.kh','mil.kh',
  			'ac.kr','co.kr','go.kr','ne.kr','or.kr','pe.kr','re.kr',
  			'seoul.kr','kyonggi.kr','com.kw','net.kw','org.kw',
  			'edu.kw','gov.kw','com.la','net.la','org.la','com.lb',
  			'org.lb','net.lb','edu.lb','gov.lb','mil.lb','com.lc',
  			'edu.lc','gov.lc','net.lc','org.lc','com.lv','net.lv',
  			'org.lv','edu.lv','gov.lv','mil.lv','id.lv','asn.lv',
  			'conf.lv','com.ly','net.ly','org.ly','co.ma','net.ma',
  			'org.ma','press.ma','ac.ma','com.mk','com.mm','net.mm',
  			'org.mm','edu.mm','gov.mm','com.mo','net.mo','org.mo',
  			'edu.mo','gov.mo','com.mt','net.mt','org.mt','edu.mt',
  			'tm.mt','uu.mt','com.mx','net.mx','org.mx','com.my',
  			'org.my','gov.my','edu.my','net.my','com.na','org.na',
  			'net.na','alt.na','edu.na','cul.na','unam.na','telecom.na',
  			'com.nc','net.nc','org.nc','ac.ng','edu.ng','sch.ng',
  			'com.ng','gov.ng','org.ng','net.ng','gob.ni','com.ni',
  			'net.ni','edu.ni','nom.ni','org.ni','com.np','net.np',
  			'org.np','gov.np','edu.np','ac.nz','co.nz','cri.nz',
  			'gen.nz','geek.nz','govt.nz','iwi.nz','maori.nz','mil.nz',
  			'net.nz','org.nz','school.nz','com.om','co.om','edu.om',
  			'ac.om','gov.om','net.om','org.om','mod.om','museum.om',
  			'biz.om','pro.om','med.om','com.pa','net.pa','org.pa',
  			'edu.pa','ac.pa','gob.pa','sld.pa','edu.pe','gob.pe',
  			'nom.pe','mil.pe','org.pe','com.pe','net.pe','com.pg',
  			'net.pg','ac.pg','com.ph','net.ph','org.ph','mil.ph',
  			'ngo.ph','aid.pl','agro.pl','atm.pl','auto.pl','biz.pl',
  			'com.pl','edu.pl','gmina.pl','gsm.pl','info.pl','mail.pl',
  			'miasta.pl','media.pl','mil.pl','net.pl',
  			'nieruchomosci.pl','nom.pl','org.pl','pc.pl','powiat.pl',
  			'priv.pl','realestate.pl','rel.pl','sex.pl','shop.pl',
  			'sklep.pl','sos.pl','szkola.pl','targi.pl','tm.pl',
  			'tourism.pl','travel.pl','turystyka.pl','com.pk','net.pk',
  			'edu.pk','org.pk','fam.pk','biz.pk','web.pk','gov.pk',
  			'gob.pk','gok.pk','gon.pk','gop.pk','gos.pk','edu.ps',
  			'gov.ps','plo.ps','sec.ps','com.py','net.py','org.py',
  			'edu.py','com.qa','net.qa','org.qa','edu.qa','gov.qa',
  			'asso.re','com.re','nom.re','com.ro','org.ro','tm.ro',
  			'nt.ro','nom.ro','info.ro','rec.ro','arts.ro','firm.ro',
  			'store.ro','www.ro','com.ru','net.ru','org.ru','gov.ru',
  			'pp.ru','com.sa','edu.sa','sch.sa','med.sa','gov.sa',
  			'net.sa','org.sa','pub.sa','com.sb','net.sb','org.sb',
  			'edu.sb','gov.sb','com.sd','net.sd','org.sd','edu.sd',
  			'sch.sd','med.sd','gov.sd','tm.se','press.se','parti.se',
  			'brand.se','fh.se','fhsk.se','fhv.se','komforb.se',
  			'kommunalforbund.se','komvux.se','lanarb.se','lanbib.se',
  			'naturbruksgymn.se','sshn.se','org.se','pp.se','com.sg',
  			'net.sg','org.sg','edu.sg','gov.sg','per.sg','com.sh',
  			'net.sh','org.sh','edu.sh','gov.sh','mil.sh','gov.st',
  			'saotome.st','principe.st','consulado.st','embaixada.st',
  			'org.st','edu.st','net.st','com.st','store.st','mil.st',
  			'co.st','com.sv','org.sv','edu.sv','gob.sv','red.sv',
  			'com.sy','net.sy','org.sy','gov.sy','ac.th','co.th',
  			'go.th','net.th','or.th','com.tn','net.tn','org.tn',
  			'edunet.tn','gov.tn','ens.tn','fin.tn','nat.tn','ind.tn',
  			'info.tn','intl.tn','rnrt.tn','rnu.tn','rns.tn',
  			'tourism.tn','com.tr','net.tr','org.tr','edu.tr','gov.tr',
  			'mil.tr','bbs.tr','k12.tr','gen.tr','co.tt','com.tt',
  			'org.tt','net.tt','biz.tt','info.tt','pro.tt','name.tt',
  			'gov.tt','edu.tt','nic.tt','us.tt','uk.tt','ca.tt','eu.tt',
  			'es.tt','fr.tt','it.tt','se.tt','dk.tt','be.tt','de.tt',
  			'at.tt','au.tt','co.tv','com.tw','net.tw','org.tw',
  			'edu.tw','idv.tw','gove.tw','com.ua','net.ua','org.ua',
  			'edu.ua','gov.ua','ac.ug','co.ug','or.ug','go.ug','co.uk',
  			'me.uk','org.uk','edu.uk','ltd.uk','plc.uk','net.uk',
  			'sch.uk','nic.uk','ac.uk','gov.uk','nhs.uk','police.uk',
  			'mod.uk','dni.us','fed.us','com.uy','edu.uy','net.uy',
  			'org.uy','gub.uy','mil.uy','com.ve','net.ve','org.ve',
  			'co.ve','edu.ve','gov.ve','mil.ve','arts.ve','bib.ve',
  			'firm.ve','info.ve','int.ve','nom.ve','rec.ve','store.ve',
  			'tec.ve','web.ve','co.vi','net.vi','org.vi','com.vn',
  			'biz.vn','edu.vn','gov.vn','net.vn','org.vn','int.vn',
  			'ac.vn','pro.vn','info.vn','health.vn','name.vn','com.vu',
  			'edu.vu','net.vu','org.vu','de.vu','ch.vu','fr.vu',
  			'com.ws','net.ws','org.ws','gov.ws','edu.ws','ac.yu',
  			'co.yu','edu.yu','org.yu','com.ye','net.ye','org.ye',
  			'gov.ye','edu.ye','mil.ye','ac.za','alt.za','bourse.za',
  			'city.za','co.za','edu.za','gov.za','law.za','mil.za',
  			'net.za','ngo.za','nom.za','org.za','school.za','tm.za',
  			'web.za','co.zw','ac.zw','org.zw','gov.zw','eu.org',
  			'au.com','br.com','cn.com','de.com','de.net','eu.com',
  			'gb.com','gb.net','hu.com','no.com','qc.com','ru.com',
  			'sa.com','se.com','uk.com','uk.net','us.com','uy.com',
  			'za.com','dk.org','tel.no','fax.nr','mob.nr','mobil.nr',
  			'mobile.nr','tel.nr','tlf.nr','e164.arpa'
      ]
    end
    
    # Parse the requesting IP address and fill corrosponding attributes
    # @param ip [String] An IP address (IPv4 only at the moment)
    def ip_address=(ip)      
      require 'digest/sha1'
      require 'resolv'
    
      logger.debug("IP: #{ip}")
    
      unless ip.blank?
        self.ip_address_hash = Digest::SHA1.hexdigest(ip)
      
        # IP
        begin
          domain_parts = Resolv.getname(ip).split('.')
        
          self.domain = "#{domain_parts[-1]}"
        
          self.domain = "#{domain_parts[-2]}.#{domain}" if domain_parts[-2]

          if two_part_domain_endings.include? self.domain
            self.domain = "#{domain_parts[-3]}.#{self.domain}"
          end
        rescue
          ip_parts = ip.split('.')
          self.domain = "#{ip_parts[0]}.#{ip_parts[1]}.x.x"
        end
      
        # GeoIP
        if ::Gricer.config.geoip_db
          if Rails.env.development?
            geoip = {:country_code=>"DE", :country_code3=>"DEU", :country_name=>"Germany", :latitude=>51.0, :longitude=>9.0} 
          else
            geoip = ::Gricer.config.geoip_db.look_up(ip)
          end
        
        
          if geoip 
            self.country = geoip[:country_code].try(:downcase)
            self.region = geoip[:region].try(:downcase)
            self.city = geoip[:city]
            self.postal_code = geoip[:postal_code]
            self.longitude = geoip[:longitude] 
            self.latitude = geoip[:latitude] 
          end
        end
      end
    end
    
    def requested_locale=(locale)
      self.requested_locale_major, self.requested_locale_minor = locale.try(:downcase).try(:split, '-')
    end
    
    def requested_locale
      if requested_locale_minor
        "#{requested_locale_major}-#{requested_locale_minor}"
      else
        requested_locale_major
      end
    end
    
    def silverlight_version=(version)
      self[:silverlight_version] = version
      self.silverlight_major_version = silverlight_version.match(/^([0-9]*\.[0-9]*)/).to_a.last if silverlight_version
    end
    
    def flash_version=(version)
      self[:flash_version] = version
      self.flash_major_version = flash_version.match(/^([0-9]*\.[0-9]*)/).to_a.last if flash_version
    end
    
    # Get the bounce rate 
    #
    # This is the rate of sessions with one request to sessions with multiple requests.
    # @return [Float]
    def self.bounce_rate
      if (c = self.count) > 0
        self.bounce_sessions.count / c.to_f
      else
        0
      end
    end
    
    # Get the average count of requests per session.
    #
    # @return [Float]
    def self.requests_per_session
      if (c = self.count) > 0
        self.sum(:requests_count) / c.to_f
      else
        0
      end
    end
    
    # Get the average duration of sessions in seconds.
    #
    # @return [Float]
    def self.avg_duration
      if (c = self.count) > 0
        logger.debug ActiveRecord::Base.connection.class
        
        if ActiveRecord::Base.connection.class.to_s == 'ActiveRecord::ConnectionAdapters::PostgreSQLAdapter'
          self.sum("date_part('epoch', \"#{self.table_name}\".\"updated_at\") - date_part('epoch', \"#{self.table_name}\".\"created_at\")").to_f / c.to_f    
        else
          self.sum("strftime('%s', \"#{self.table_name}\".\"updated_at\") - strftime('%s', \"#{self.table_name}\".\"created_at\")") / c.to_f
        end
      else
        0
      end
    end
    
    # Get the duration of the current session instance
    def duration
      updated_at - created_at
    end
    
    # Get the new visitor rate
    #
    # This is the rate of new sessions to all sessions
    # return [Float]
    def self.new_visitors
      if (c = self.count) > 0
        self.new_visits.count / c.to_f
      else
        0
      end
    end
  end
end