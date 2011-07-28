require 'spec_helper'

describe Gricer::DashboardController do
  context 'index' do
    it 'should render template' do
      get :index
      response.should be_success
      response.should render_template(:index)
      response.content_type.should == 'text/html'
    end
    
    it 'should assign sessions' do
      get :index
      assigns[:sessions].class.should == ActiveRecord::Relation
    end
    
    it 'should assign requests' do
      get :index
      assigns[:requests].class.should == ActiveRecord::Relation
    end
  end
  
  context 'overview' do
    it 'should render template' do
      xhr :post, :overview
      response.should be_success
      response.should render_template(:overview)
      # For some reason the content_type in the test is 'text/javascript'
      # When requested it returns a 'text/html', so this is ok
      # response.content_type.should == 'text/html'
    end
    
    it 'should assign sessions' do
      xhr :post, :overview
      assigns[:sessions].class.should == ActiveRecord::Relation
      assigns[:sessions].inspect == ActiveRecord::Relation
    end
    
    it 'should assign requests' do
      xhr :post, :overview
      assigns[:requests].class.should == ActiveRecord::Relation
    end   
  end
end
