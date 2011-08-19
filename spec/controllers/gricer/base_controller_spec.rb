require 'spec_helper'

describe Gricer::BaseController do  
  context 'process_stats' do
    let(:collection) { mock_model('MyStatClass') }
    
    before do
      controller.params = {
        field: 'my_field',
        filters: nil,
        from: '2011-04-01',
        thru: '2011-04-05'
      }
      controller.send(:guess_from_thru)
      controller.stub(:basic_collection) {collection}
 
      controller.stub(:url_for).with(action: "spread_stats", field: 'my_field', filters: nil, only_path: true) { 'my_alt_url' }
            
      collection.stub(:stat) { {some: :values} }
    end
    
    it 'should render ajax' do
      controller.stub(:render).with(json: {
        alternatives: [
          {type: "spread", uri: "my_alt_url"}, 
          {type: "process"}
        ], 
        from: 1301608800000, 
        thru: 1301954400000, 
        step: 3600000, 
        data: {some: :values}
      })
      
      controller.send(:process_stats)
    end
    
    it 'should render ajax with filter' do
      controller.stub(:url_for).with(action: "spread_stats", field: 'my_field', filters: {"filter"=>"some_value"}, only_path: true) { 'my_filtered_alt_url' }
      
      controller.params[:filters] = {'filter' => 'some_value'}
      
      controller.stub(:render).with(json: {
        alternatives: [
          {type: "spread", uri: "my_filtered_alt_url"}, 
          {type: "process"}
        ], 
        from: 1301608800000, 
        thru: 1301954400000, 
        step: 3600000, 
        data: {some: :values}
      })
      
      collection.should_receive(:filter_by).with('filter', 'some_value') { collection }
      
      controller.send(:process_stats)
    end
    
    it 'should render ajax with further details' do
      controller.stub(:further_details) { {'my_field' => 'my_detail_field'} }
      controller.stub(:url_for).with({:action=>"process_stats", :field=>"my_detail_field", :filters=>{"my_field"=>"%{self}"}, :only_path=>true}) {'my_detail_url'}
      
      controller.stub(:render).with(json: {
        alternatives: [
          {type: "spread", uri: "my_alt_url"}, 
          {type: "process"}
        ], 
        from: 1301608800000, 
        thru: 1301954400000, 
        step: 3600000, 
        data: {some: :values},
        detail_uri: 'my_detail_url'
      })
      
      controller.send(:process_stats)
    end
  end
  
  context 'spread_stats' do
    let(:collection) { mock_model('MyStatClass') }    
    before do
      controller.params = {
        field: 'my_field',
        filters: nil,
        from: '2011-04-01',
        thru: '2011-04-05'
      }
      controller.send(:guess_from_thru)
      controller.stub(:basic_collection) {collection}
 
      controller.stub(:url_for).with(action: "process_stats", field: 'my_field', filters: nil, only_path: true) { 'my_alt_url' }
            
      collection.stub(:between_dates) { collection }
      collection.stub(:count).with(:id) { 42 }
      collection.stub(:count_by).with('my_field') { [['Item 1', 23], ['Item 2', 19]]}
    end
    
    it 'should render ajax' do
      controller.stub(:render).with(json: {
        alternatives: [
          {type: "spread"}, 
          {type: "process", uri: "my_alt_url"}
        ], 
        from: 1301608800000, 
        thru: 1301954400000, 
        total: 42, 
        data: [["Item 1", 23], ["Item 2", 19]]
      })
      
      controller.send(:spread_stats)
    end
    
    it 'should render ajax with filter' do
      controller.stub(:url_for).with(action: "process_stats", field: 'my_field', filters: {"filter"=>"some_value"}, only_path: true) { 'my_filtered_alt_url' }
      
      controller.params[:filters] = {'filter' => 'some_value'}
      
      controller.stub(:render).with(json: {
        alternatives: [
          {type: "spread"}, 
          {type: "process", uri: "my_filtered_alt_url"}
        ], 
        from: 1301608800000, 
        thru: 1301954400000, 
        total: 42, 
        data: [["Item 1", 23], ["Item 2", 19]]
      })
      
      collection.should_receive(:filter_by).with('filter', 'some_value') { collection }
      
      controller.send(:spread_stats)
    end
    
    it 'should render ajax with further details' do
      controller.stub(:further_details) { {'my_field' => 'my_detail_field'} }
      controller.stub(:url_for).with({:action=>"spread_stats", :field=>"my_detail_field", :filters=>{"my_field"=>"%{self}"}, :only_path=>true}) {'my_detail_url'}
      
      controller.stub(:render).with(json: {
        alternatives: [
          {type: "spread"}, 
          {type: "process", uri: "my_alt_url"}
        ], 
        from: 1301608800000, 
        thru: 1301954400000, 
        total: 42, 
        data: [["Item 1", 23], ["Item 2", 19]],
        detail_uri: 'my_detail_url'
      })
      
      controller.send(:spread_stats)
    end 
  end
  
  context 'basic_collection' do
    it 'should raise error (as it has to be implemented in child classes)' do
      proc{ controller.send(:basic_collection) }.should raise_error('basic_collection must be defined')
    end
  end
  
  context 'handle_special_fields' do
    it 'should do nothing' do
      controller.send(:handle_special_fields).should be_nil
    end
  end
  
  context 'further_details' do
    it 'should return empty hash' do
      controller.send(:further_details).should == {}
    end
  end
  
  context 'guess_from_thru' do
    it 'should assign sane values' do
      Time.stub(:now) {'2011-04-01 12:42:23'.to_time}
      
      controller.send(:guess_from_thru)
      assigns[:stat_from].should == '2011-03-25'.to_date
      assigns[:stat_thru].should == '2011-03-31'.to_date
      assigns[:stat_step].should == 1.hour
    end
    
    it 'should assign given values' do
      controller.params[:from] = '2010-06-15'
      controller.params[:thru] = '2011-06-15'
      
      controller.send(:guess_from_thru)
      assigns[:stat_from].should == '2010-06-15'.to_date
      assigns[:stat_thru].should == '2011-06-15'.to_date
      assigns[:stat_step].should == 1.day
    end
    
    it 'should assign sane values with from given' do
      controller.params[:from] = '2011-03-15'
      
      controller.send(:guess_from_thru)
      assigns[:stat_from].should == '2011-03-15'.to_date
      assigns[:stat_thru].should == '2011-03-21'.to_date
      assigns[:stat_step].should == 1.hour
    end

    it 'should assign sane values with from thru' do
      controller.params[:thru] = '2009-08-15'
      
      controller.send(:guess_from_thru)
      assigns[:stat_from].should == '2009-08-09'.to_date
      assigns[:stat_thru].should == '2009-08-15'.to_date
      assigns[:stat_step].should == 1.hour
    end
  end
end
