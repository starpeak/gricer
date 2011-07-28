require 'spec_helper'

describe Gricer::TrackRequestFilter do
  context 'filter out specific urls' do
    let(:request) do
      mock 'Request',
        remote_ip: '127.0.0.1',
        host: 'localhost',
        path: '/my_action',
        request_method: 'GET',
        protocol: 'http://',
        headers: {}
    end
    
    let(:response) do
      mock 'Response',
        content_type: 'text/html',
        body: '<html><head></head><body></body></html>',
        status: 404
    end
    
    let(:controller) do 
      mock 'MyController',
        controller_path: 'my_controller',
        action_name: 'my_action',
        params: {},
        session: {},
        gricer_user_id: nil,
        request: request,
        response: response
    end
    
    before do
      controller.stub(:gricer_request=)
    end
    
    it 'should not track /gricer urls' do
      controller.stub(:controller_path) { 'gricer/capture' }
      
      my_command = mock 'MyCommand'
      my_command.should_receive(:test)
      Gricer::Request.should_not_receive(:create)
      
      Gricer::TrackRequestFilter.filter controller do
        my_command.test
      end
    end
    
    it 'should not track configured urls' do
      request.stub(:path) { '/this/is/my/exception' }
      
      Gricer.config.stub(:exclude_paths) { /^\/this/ }
      
      my_command = mock 'MyCommand'
      my_command.should_receive(:test)
      Gricer::Request.should_not_receive(:create)
      
      Gricer::TrackRequestFilter.filter controller do
        my_command.test
      end
    end
  end
end