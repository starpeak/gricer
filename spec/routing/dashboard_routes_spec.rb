require 'spec_helper'

describe 'routes for admin dashboard' do
  it { gricer_root_path.should == '/gricer' }
  it { { get: '/gricer'}.should route_to(controller: 'gricer/dashboard', action: 'index') }
  
  it { gricer_overview_path.should == '/gricer/overview' }
  it { { post: '/gricer/overview'}.should route_to(controller: 'gricer/dashboard', action: 'overview') }
end