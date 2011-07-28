require 'spec_helper'

describe 'routes for javascript value capture' do
  it { gricer_capture_path(42).should == '/gricer_capture/42' }
  it { { post: '/gricer_capture/42'}.should route_to(controller: 'gricer/capture', action: 'index', id: '42') }
end