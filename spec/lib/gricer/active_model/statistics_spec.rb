require 'spec_helper'

describe Gricer::ActiveModel::Statistics do
  
  class ActiveRecordStatModel < ActiveRecord::Base
    include Gricer::ActiveModel::Statistics
    
    belongs_to :parent, class_name: 'ActiveRecordParentModel'
  end
  
  class ActiveRecordParentModel < ActiveRecord::Base
    has_many :children, class_name: 'ActiveRecordStatModel', foreign_key: :parent_id
  end
  
  class MongoidStatModel
    include Mongoid::Document
    include Mongoid::Timestamps
    include Gricer::ActiveModel::Statistics
    
    belongs_to :parent, class_name: 'MongoidParentModel'
    
    field :title, type: String
  end
  
  class MongoidParentModel
    include Mongoid::Document
    
    has_many :children, class_name: 'MongoidStatModel', foreign_key: :parent_id
    
    field :version, type: String
  end
  
  before :all do
    silence_streams(STDOUT) do
      ActiveRecord::Migration.class_eval do
        begin
          drop_table :active_record_parent_models 
        rescue
        end
      
        begin
          drop_table :active_record_stat_models 
        rescue
        end
      
      
        create_table :active_record_stat_models do |t|
          t.references :parent
          t.string  :title
          t.timestamps
        end 
      
        create_table :active_record_parent_models do |t|
          t.string  :version
        end 
      end
    end
  end
  
  after :all do
    silence_streams(STDOUT) do
      ActiveRecord::Migration.class_eval do
        drop_table :active_record_parent_models 
        drop_table :active_record_stat_models 
      end
    end
  end
  
  [:ActiveRecord, :Mongoid].each do |model_type|
    context "Running for #{model_type} models" do
      let(:stat_model) { "#{model_type}StatModel".constantize }
      let(:parent_model) { "#{model_type}ParentModel".constantize }
      
      before :each do
        stat_model.destroy_all
        parent_model.destroy_all
        
        parent = parent_model.create version: '42'
        stat_model.create title: 'Firefox', created_at: '2011-12-24 11:42'.to_time
        stat_model.create title: 'Safari', created_at: '2012-02-17 12:42'.to_time
        stat_model.create parent: parent, title: 'Chrome', created_at: '2012-02-18 23:12'.to_time
        stat_model.create parent: parent, title: 'Safari', created_at: '2012-02-19 03:42'.to_time
      end
      
      context "self.is_active_record?" do
        it "returns #{(model_type == :ActiveRecord)}" do
          stat_model.is_active_record?.should == (model_type == :ActiveRecord)
        end
      end
      
      context "self.model_type" do
        it "returns symbol #{model_type}" do
          stat_model.model_type.should == model_type
        end
      end
      
      context "self.between" do        
        it "filters for entries created after start date" do
          query = stat_model.between('2012-02-03 12:00'.to_time, '2012-02-18 23:23'.to_time)
          #query.count.should == 2
          query.map{|x| x.title}.should == ["Safari", "Chrome"]
        end  
          
          
        it "filters for entries created on start date" do
          query = stat_model.between('2012-02-18 20:00'.to_time, '2012-02-25 12:00'.to_time)
          #query.count.should == 2
          query.map{|x| x.title}.should == ["Chrome", "Safari"]
        end
        
        it "filters for entries created before end date" do
          query = stat_model.between('2010-02-03 12:00'.to_time, '2012-02-17 12:41'.to_time)
          #query.count.should == 1
          query.map{|x| x.title}.should == ["Firefox"] 
        end
      end
      
      context "self.between_dates" do        
        it "filters for entries created after start date" do
          query = stat_model.between_dates('2012-02-03'.to_time, '2012-02-25'.to_time)
          #query.count.should == 3
          query.map{|x| x.title}.should == ["Safari", "Chrome", "Safari"]
        end  
          
          
        it "filters for entries created on start date" do
          query = stat_model.between_dates('2012-02-18'.to_time, '2012-02-25'.to_time)
          #query.count.should == 2
          query.map{|x| x.title}.should == ["Chrome", "Safari"]
        end
        
        it "filters for entries created before end date" do
          query = stat_model.between_dates('2010-02-03'.to_time, '2012-02-16'.to_time)
          #query.count.should == 1
          query.map{|x| x.title}.should == ["Firefox"] 
        end
      end
      
      context "self.grouped_by" do
        # only used by count_by in AR - so no explicit test here atm
      end
      
      context "self.count_by" do
        
        it "counts entries by string" do
          stat_model.count_by('title').should == [["Safari", 2], ["Firefox", 1], ["Chrome", 1]]
        end
        
        it "counts entries by symbol" do
          stat_model.count_by(:title).should == [["Safari", 2], ["Firefox", 1], ["Chrome", 1]]
        end
        
        it "counts entries by gricer selector string" do
          stat_model.count_by('parent.version').should == [[nil, 2], ["42", 2]]
        end
        
        it "counts entries on filtered collection" do
          stat_model.between_dates('2012-02-03'.to_time, '2012-02-25'.to_time).count_by('title').should == [["Safari", 2], ["Chrome", 1]]
        end
      end
      
      context "self.filter_by" do
        it "by string" do
          query = stat_model.filter_by('title', 'Safari')
          #query.count.should == 2
          query.map{|x| x.title}.should == ['Safari', 'Safari']
        end
        
        it "by symbol" do
          query = stat_model.filter_by(:title, 'Safari')
          #query.count.should == 2
          query.map{|x| x.title}.should == ['Safari', 'Safari']
        end
        
        it "by gricer selector string" do
          query = stat_model.filter_by("parent.version", '42')
          #query.count.should == 2
          query.map{|x| x.title}.should == ["Chrome", "Safari"]
        end
        
      end
      
      context "self.without_nil_in" do
        before :each do
          stat_model.destroy_all
          
          stat_model.create title: 'Given Entry'
          stat_model.create title: nil
        end
        
        it "removes nil title entries from result by string" do
          query = stat_model.without_nil_in('title')
          #query.count.should == 1
          query.map{|x| x.title}.should == ['Given Entry']
        end
        
        it "removes nil title entries from result by symbol" do
          query = stat_model.without_nil_in(:title)
          #query.count.should == 1
          query.map{|x| x.title}.should == ['Given Entry']
        end
      end
      
      context "self.stat" do        
        it "calculates stat over entries by string" do
          stat_model.stat('title', '2012-02-17'.to_time, '2012-02-19'.to_time).should == {"Safari"=>[[1329480000000, 1], [1329620400000, 1]], "Chrome"=>[[1329606000000, 1]]}
        end
        
        it "calculates stat over entries by string" do
          stat_model.stat(:title, '2012-02-17'.to_time, '2012-02-19'.to_time).should == {"Safari"=>[[1329480000000, 1], [1329620400000, 1]], "Chrome"=>[[1329606000000, 1]]}
        end
      end
      
      context "model_type" do
        it "returns symbol #{model_type}" do
          stat_model.new.model_type.should == model_type
        end
      end
    end
  end
end
