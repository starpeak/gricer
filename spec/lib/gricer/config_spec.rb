require 'spec_helper'

describe Gricer::Config do
  context 'table_name_prefix' do
    it "has default value" do
      subject.table_name_prefix.should == 'gricer_'
    end
    
    it "allows custom value" do
      subject.table_name_prefix = 'tracking_'
      subject.table_name_prefix.should == 'tracking_'
    end
    
    it "allows resetting to default" do
      subject.table_name_prefix = nil
      subject.table_name_prefix.should == 'gricer_'
    end
  end
  
  context 'admin_prefix' do
    it "has default value" do
      subject.admin_prefix.should == 'gricer'
    end
    
    it "allows custom value" do
      subject.admin_prefix = 'stats'
      subject.admin_prefix.should == 'stats'
    end
    
    it "allows resetting to default" do
      subject.admin_prefix = nil
      subject.admin_prefix.should == 'gricer'
    end
  end
  
  context 'admin_layout' do
    it "has default value" do
      subject.admin_layout.should be_nil
    end
    
    it "allows custom value" do
      subject.admin_layout = 'tracking'
      subject.admin_layout.should == 'tracking'
    end
    
    it "allows resetting to default" do
      subject.admin_layout = nil
      subject.admin_layout.should be_nil
    end
  end  
  
  context 'admin_menu' do
    let(:default) {[["overview", :dashboard, {:controller=>"gricer/dashboard", :action=>"overview"}], ["visitors", :menu, [["entry_pages", :spread, {:controller=>"gricer/requests", :action=>"spread_stats", :field=>"entry_path"}], ["referers", :spread, {:controller=>"gricer/requests", :action=>"spread_stats", :field=>"referer_host"}], ["search_engines", :spread, {:controller=>"gricer/requests", :action=>"spread_stats", :field=>"search_engine"}], ["search_terms", :spread, {:controller=>"gricer/requests", :action=>"spread_stats", :field=>"search_query"}], ["countries", :spread, {:controller=>"gricer/sessions", :action=>"spread_stats", :field=>"country"}], ["domains", :spread, {:controller=>"gricer/sessions", :action=>"spread_stats", :field=>"domain"}], ["locales", :spread, {:controller=>"gricer/sessions", :action=>"spread_stats", :field=>"requested_locale_major"}]]], ["pages", :menu, [["views", :spread, {:controller=>"gricer/requests", :action=>"spread_stats", :field=>"path"}], ["hosts", :spread, {:controller=>"gricer/requests", :action=>"spread_stats", :field=>"host"}], ["methods", :spread, {:controller=>"gricer/requests", :action=>"spread_stats", :field=>"method"}], ["protocols", :spread, {:controller=>"gricer/requests", :action=>"spread_stats", :field=>"protocol"}]]], ["browsers", :menu, [["browsers", :spread, {:controller=>"gricer/sessions", :action=>"spread_stats", :field=>"agent.name"}], ["operating_systems", :spread, {:controller=>"gricer/sessions", :action=>"spread_stats", :field=>"agent.os"}], ["engines", :spread, {:controller=>"gricer/sessions", :action=>"spread_stats", :field=>"agent.engine_name"}], ["javascript", :spread, {:controller=>"gricer/sessions", :action=>"spread_stats", :field=>"javascript"}], ["java", :spread, {:controller=>"gricer/sessions", :action=>"spread_stats", :field=>"java"}], ["silverlight", :spread, {:controller=>"gricer/sessions", :action=>"spread_stats", :field=>"silverlight_major_version"}], ["flash", :spread, {:controller=>"gricer/sessions", :action=>"spread_stats", :field=>"flash_major_version"}], ["screen_sizes", :spread, {:controller=>"gricer/sessions", :action=>"spread_stats", :field=>"screen_size"}], ["color_depths", :spread, {:controller=>"gricer/sessions", :action=>"spread_stats", :field=>"screen_depth"}]]]]}
    
    it "has default value" do
      subject.admin_menu.should == default
    end
    
    it "allows custom value" do
      subject.admin_menu = [
        ['overview', :dashboard, {controller: 'gricer/dashboard', action: 'overview'}]
      ]
      subject.admin_menu.should == [
        ['overview', :dashboard, {controller: 'gricer/dashboard', action: 'overview'}]
      ]
    end
    
    it "allows resetting to default admin_menu" do
      subject.admin_menu = nil
      subject.admin_menu.should == default
    end
  end

  context 'exclude_paths' do
    it "has default value" do
      subject.exclude_paths.should == /^#{subject.admin_prefix}$/
    end
    
    it "allows custom value" do
      subject.exclude_paths = /^private$/
      subject.exclude_paths.should == /^private$/
    end
    
    it "allows resetting to default" do
      subject.exclude_paths = nil
      subject.exclude_paths.should == /^#{subject.admin_prefix}$/
    end
  end
  
  context 'geoip_dat' do
    it "has default value" do
      subject.geoip_dat.should be_nil
    end
    
    it "allows custom value" do
      subject.geoip_dat = '/tmp/geoip.dat'
      subject.geoip_dat.should == '/tmp/geoip.dat'
    end
    
    it "allows resetting to default" do
      subject.geoip_dat = nil
      subject.geoip_dat.should be_nil
    end
  end
  
  context 'geoip_db' do
    it "has default value" do
      subject.geoip_db.should be_nil
    end
    
    it "allows custom value" do
      module GeoIP
        class City
        end
      end
      
      GeoIP::City.should_receive(:new).with('/tmp/geoip.dat', :index, false) { 'GeoIP::City::Object' }
      
      subject.geoip_dat = '/tmp/geoip.dat'
      subject.geoip_db.should == 'GeoIP::City::Object'
    end
    
    it "allows resetting to default" do
      subject.geoip_db = nil
      subject.geoip_db.should be_nil
    end
  end

  context 'max_session_duration' do
    it "has default value" do
      subject.max_session_duration.should == 15.minutes
    end
    
    it "allows custom value" do
      subject.max_session_duration = 42.minutes
      subject.max_session_duration.should == 42.minutes
    end
    
    it "allows resetting to default" do
      subject.max_session_duration = nil
      subject.max_session_duration.should == 15.minutes
    end
  end
  
  context 'model_type' do
    it "has default value" do
      subject.model_type.should == :ActiveRecord
    end

    it "allows custom value" do
      subject.model_type = :Mongoid
      subject.model_type.should == :Mongoid
    end

    it "allows resetting to default" do
      subject.model_type = nil
      subject.model_type.should == :ActiveRecord
    end
  end
  
  context 'session_model' do
    it "has default value" do
      subject.session_model.should == Gricer::ActiveRecord::Session
    end

    it "allows custom value" do
      subject.model_type = :Mongoid
      subject.session_model.should == Gricer::Mongoid::Session
    end

    it "allows resetting to default" do
      subject.model_type = nil
      subject.session_model.should == Gricer::ActiveRecord::Session
    end
  end

  context 'request_model' do
    it "has default value" do
      subject.request_model.should == Gricer::ActiveRecord::Request
    end

    it "allows custom value" do
      subject.model_type = :Mongoid
      subject.request_model.should == Gricer::Mongoid::Request
    end

    it "allows resetting to default" do
      subject.model_type = nil
      subject.request_model.should == Gricer::ActiveRecord::Request
    end
  end

  context 'agent_model' do
    it "has default value" do
      subject.agent_model.should == Gricer::ActiveRecord::Agent
    end

    it "allows custom value" do
      subject.model_type = :Mongoid
      subject.agent_model.should == Gricer::Mongoid::Agent
    end

    it "allows resetting to default" do
      subject.model_type = nil
      subject.agent_model.should == Gricer::ActiveRecord::Agent
    end
  end
end