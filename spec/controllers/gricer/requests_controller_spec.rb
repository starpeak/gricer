require 'spec_helper'

describe Gricer::RequestsController do
  context 'process_stats' do
    it 'should render json' do
      xhr :get, :process_stats, field: :path
      response.should be_success
      response.content_type.should == 'application/json'
    end
  end
  
  context 'spread_stats' do
    it 'should render json' do
      xhr :get, :spread_stats, field: :path
      response.should be_success
      response.content_type.should == 'application/json'
    end
  end
  
  context 'basic_collection' do
    it 'should define basic collection' do
      Gricer::Request.should_receive(:browsers) { 'collection' }    
      collection = controller.send(:basic_collection)
      collection.should == 'collection'    end
  end
  
  context 'further_details' do
    it 'should return a hash' do
      controller.send(:further_details).class.should == Hash
    end
    
    it 'should have many entries' do
      controller.send(:further_details).size.should > 1
    end
  end
end
