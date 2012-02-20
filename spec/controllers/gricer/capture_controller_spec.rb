require 'spec_helper'

describe Gricer::CaptureController do
  for_all_databases do
    context 'index' do
      it 'should handle proper request' do
        gricer_session = mock_model(Gricer.config.session_model)
        gricer_request = mock_model(Gricer.config.request_model, session: gricer_session)
        controller.stub(:session) { { gricer_session: 42 } }
        Gricer.config.session_model.should_receive(:first_by_id).with(42) { gricer_session }
        Gricer.config.request_model.should_receive(:first_by_id).with('23') { gricer_request }
  
        gricer_session.should_receive(:javascript=).with(true)
        gricer_session.should_receive(:java=).with('true')
        gricer_session.should_receive(:flash_version=).with('10.0 r45')
        gricer_session.should_receive(:silverlight_version=).with('4.0.51204.0')
        gricer_session.should_receive(:screen_width=).with('1024')
        gricer_session.should_receive(:screen_height=).with('768')
        gricer_session.should_receive(:screen_size=).with('1024x768')
        gricer_session.should_receive(:screen_depth=).with('8')

        gricer_session.should_receive(:save) { true }
  
        gricer_request.should_receive(:javascript=).with(true)
        gricer_request.should_receive(:window_width=).with('800')
        gricer_request.should_receive(:window_height=).with('600')

        gricer_request.should_receive(:save) { true }    
  
        xhr(
          :post, 
          :index, 
          id: '23',
          f: '10.0 r45',
          j: 'true',
          sl: '4.0.51204.0',
          sx: '1024', 
          sy: '768', 
          sd: '8', 
          wx: '800',
          wy: '600'
        )
      end
    end
  end
end
